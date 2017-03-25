defmodule PatternsControlTest do
  use ExUnit.Case
  doctest PatternsControl

  alias PatternsControl.{BridgeServer, BridgeSupervisor}

  @ip_address "123.123.123.123"

  setup do
    PatternsControl.clear_bridges(@ip_address)
  end

  test "application should have a BridgeServer" do
    pid = GenServer.whereis(BridgeServer)

    assert Process.alive?(pid)
  end

  test "application should have a BridgeSupervisor" do
    pid = GenServer.whereis(BridgeSupervisor)

    assert Process.alive?(pid)
  end

  test "Connector and BridgeSupervisor should have a Supervisor" do
    bridge_sup = GenServer.whereis(BridgeSupervisor)
    connector = GenServer.whereis(BridgeServer)

    children = Supervisor.which_children(PatternsControl.Supervisor)
               |> Enum.map(fn {_, pid, _, _} -> pid end)

    assert bridge_sup in children
    assert connector in children
  end

  describe "BridgeServer" do
    test "can create new bridges" do
      {:ok, pid} = PatternsControl.create_bridge(@ip_address)

      assert is_pid(pid)
      assert Process.alive?(pid)
    end

    test "can get bridges" do
      {:ok, pid} = PatternsControl.create_bridge(@ip_address)
      bridges = PatternsControl.get_bridges(@ip_address)

      assert pid in bridges
    end

    test "can clear bridges" do
      PatternsControl.create_bridge(@ip_address)
      :ok = PatternsControl.clear_bridges(@ip_address)

      assert [] = PatternsControl.get_bridges(@ip_address)
    end
  end
end
