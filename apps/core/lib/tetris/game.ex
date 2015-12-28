defmodule Tetris.Game do
  use GenServer

  @doc """
  Starts a new game  of Tetris
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Tells you if the game is started yet
  """
  def started?(game) do
    GenServer.call(game, {:is_started})
  end

  @doc """
  Tells you if the game is ready yet
  """
  def ready?(game) do
    GenServer.call(game, {:is_ready})
  end

  @doc """
  Tells you if more players can join the game
  """
  def full?(game) do
    GenServer.call(game, {:is_full})
  end

  @doc """
  Tells you if the player is playing in that game

  iex> {:ok, game} = Tetris.Game.start_link
  iex> player = %Tetris.Player{name: 'Olaf'}
  iex> Tetris.Game.player?(game, player)
  false
  iex> Tetris.Game.add_player(game, player)
  iex> Tetris.Game.player?(game, player)
  true
  """
  def player?(game, player) do
    GenServer.call(game, {:get_players}) |> Enum.member? player
  end

  @doc """
  Adds a player to the game until it's full

  Returns `:ok` or `{:error, :ERROR_ID}`
  """
  def add_player(game, player) do
    if Tetris.Game.full?(game) do
      {:error, :GAME_IS_FULL}
    else
      GenServer.call(game, {:add_player, player})
    end
  end


  @doc """
  Returns all current players
  """
  def players(game) do
    GenServer.call(game, {:get_players})
  end


  @doc """
  Returns a new random stone
  """
  def next_stone(game) do
    GenServer.call(game, {:next_stone})
  end

  @doc """
  Starts a game if it is ready.

  Returns `:ok` if it is now started or `{:error, :GAME_NOT_READY}` otherwise
  """
  def start_game(game) do
    if Tetris.Game.ready?(game) do
      GenServer.call(game, {:start_game})
    else
      {:error, :GAME_NOT_READY}
    end
  end

  @doc """
  Returns the board of given player.

  It returns `{:error, :PLAYER_NOT_FOUND}` if player is not participating in that game
  """
  def board_of(game, player) do
    if Tetris.Game.player?(game, player) do
      GenServer.call(game, {:start_game})
    else
      {:error, :PLAYER_NOT_FOUND}
    end
  end


  ## Server Callbacks

  def init(:ok) do
    :random.seed(:erlang.now())
    state = %{players: [], started: false}
    {:ok, state}
  end

  def handle_call({:is_started}, _from, state) do
    {:reply, state.started, state}
  end

  def handle_call({:get_players}, _from, state) do
    {:reply, state.players, state}
  end

  def handle_call({:is_ready}, _from, state) do
    result = !state.started && Enum.count(state.players) >= 1
    {:reply, result, state}
  end

  def handle_call({:is_full}, _from, state) do
    result = Enum.count(state.players) == 2
    {:reply, result, state}
  end

  def handle_call({:next_stone}, _from, state) do
    {:reply, Tetris.Tetramino.create_random, state}
  end

  def handle_call({:start_game}, _from, state) do
    state = Dict.put(state, :started, true)
    state = Dict.put(state, :players, Enum.map(state.players, fn (player) ->
      {:ok, board} = Tetris.Board.start_link next_stone_callback: fn -> Tetris.Tetramino.create_random end
      Tetris.Board.set_stone board, Tetris.Tetramino.create_random
      %Tetris.Player{player | board: board}
    end))

    {:reply, :ok, state}
  end

  def handle_call({:add_player, player}, _from, state) do
    new_state = Dict.put(state, :players, [player | state.players])
    {:reply, :ok, new_state}
  end

end
