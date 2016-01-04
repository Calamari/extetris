defmodule Tetris.GameTest do
  use ExUnit.Case, async: true
  doctest Tetris.Game

  setup do
    {:ok, game} = Tetris.Game.start_link
    {:ok, game: game}
  end

  test "created game is not started and not ready yet", %{game: game} do
    assert Tetris.Game.started?(game) == false
    assert Tetris.Game.ready?(game) == false
    assert Tetris.Game.full?(game) == false
  end

  test "we can add players until it is full (all players set)", %{game: game} do
    Tetris.Game.add_player(game, %Tetris.Player{name: 'Bob' })

    assert Tetris.Game.ready?(game) == true
    assert Tetris.Game.full?(game) == false

    Tetris.Game.add_player(game, %Tetris.Player{name: 'Doe' })

    assert Tetris.Game.ready?(game) == true
    assert Tetris.Game.full?(game) == true
    assert Tetris.Game.started?(game) == false

    assert {:error, :GAME_IS_FULL} == Tetris.Game.add_player(game, %Tetris.Player{name: 'tomuch' })
  end

  test "we can only start a ready game", %{game: game} do
    assert {:error, :GAME_NOT_READY} == Tetris.Game.start_game(game)

    Tetris.Game.add_player(game, %Tetris.Player{name: 'John' })

    assert :ok == Tetris.Game.start_game(game)
  end

  test "starting a game gives every player a board and a stone ", %{game: game} do
    Tetris.Game.add_player(game, %Tetris.Player{name: 'John' })
    Tetris.Game.add_player(game, %Tetris.Player{name: 'Doe' })
    Tetris.Game.start_game(game)

    [player1, player2] = Tetris.Game.players(game)
    assert is_pid player1.board
    assert is_pid player2.board

    stone1 = Tetris.Board.get_current_stone(player1.board)
    assert !is_nil stone1

    stone2 = Tetris.Board.get_current_stone(player1.board)
    assert !is_nil stone2
  end

  # test "#start_game can also start a game loop", %{game: game} do
  #   Tetris.Game.add_player(game, %Tetris.Player{name: 'Doe' })
  #   Tetris.Game.start_game(game, loop: true)

  #   [player1, player2] = Tetris.Game.players(game)
  #   assert is_pid player1.board
  # end

  # TODO: Do this functionality and then uncomment it.
  #       Maybe do this as game config.
  # test "starting a game selects the same stone for every board", %{game: game} do
  #   Tetris.Game.add_player(game, %Tetris.Player{name: 'John' })
  #   Tetris.Game.add_player(game, %Tetris.Player{name: 'Doe' })
  #   Tetris.Game.start_game(game)

  #   [player1, player2] = Tetris.Game.players(game)
  #   stone1 = Tetris.Board.get_current_stone(player1.board)
  #   stone2 = Tetris.Board.get_current_stone(player2.board)

  #   assert stone1.x == 3
  #   assert stone1.y == 0
  #   assert stone1 == stone2
  # end

  test "#next_stone will return a randomly generated new stone", %{game: game} do
    Tetris.Game.add_player(game, %Tetris.Player{name: 'Doe' })
    Tetris.Game.start_game(game)

    stone1 = Tetris.Game.next_stone game
    stone2 = Tetris.Game.next_stone game

    assert stone1 != stone2
  end
end
