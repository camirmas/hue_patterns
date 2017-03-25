defmodule PatternsControl.Light do
  use GenServer

  # API

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  # Callbacks

  def init(_) do
    {:ok, %{color: nil}}
  end
end
