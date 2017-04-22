defmodule PatternsControl.BridgeSupervisor do
  use Supervisor
  import Supervisor.Spec

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    opts = [restart: :transient]
    children = [
      worker(PatternsControl.Bridge, [], opts)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
