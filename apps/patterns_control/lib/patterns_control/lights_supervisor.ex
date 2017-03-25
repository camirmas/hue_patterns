defmodule PatternsControl.LightsSupervisor do
  use Supervisor
  import Supervisor.Spec

  def start_link do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [], name: __MODULE__)
    start_workers(sup)

    result
  end

  def init(_) do
    supervise([], strategy: :one_for_all)
  end

  def start_workers(sup) do
    {:ok, light_sup} = Supervisor.start_child(sup, supervisor(PatternsControl.LightSupervisor, []))
    # If the Server goes down, take it all down and restart
    Supervisor.start_child(sup, worker(PatternsControl.LightServer, [light_sup]))
  end
end
