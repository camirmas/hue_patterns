defmodule PatternsControl.LightServer do
  use GenServer

  # API

  def start_link(sup) do
    GenServer.start_link(__MODULE__, sup, [])
  end

  # Callbacks

  def init(sup) do
    {:ok, %{sup: sup}}
  end
end
