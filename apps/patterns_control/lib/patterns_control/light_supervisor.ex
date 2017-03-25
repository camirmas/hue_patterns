defmodule PatternsControl.LightSupervisor do
  use Supervisor
  import Supervisor.Spec

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      worker(PatternsControl.Light, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
