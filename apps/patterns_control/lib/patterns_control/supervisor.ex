defmodule PatternsControl.Supervisor do
  use Supervisor
  import Supervisor.Spec

  alias PatternsControl.BridgeSupervisor
  alias PatternsControl.BridgeServer

  def start_link do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [], name: __MODULE__)
    start_workers(sup)

    result
  end

  def init(_) do
    supervise([], strategy: :one_for_one)
  end

  def start_workers(sup) do
    {:ok, bridge_sup} = Supervisor.start_child(sup, supervisor(BridgeSupervisor, []))
    Supervisor.start_child(sup, worker(BridgeServer, [bridge_sup]))
  end
end
