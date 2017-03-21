defmodule PatternsControl.Connector do
  use GenServer

  # API

  def start_link(sup) do
    GenServer.start_link(__MODULE__, sup, name: __MODULE__)
  end

  def connect(ip_address) do
    GenServer.call(__MODULE__, {:connect, ip_address})
  end

  # Callbacks

  def init(sup) do
    {:ok, %{sup: sup}}
  end

  def handle_call({:connect, ip_address}, _from, %{sup: sup} = state) do
    {:ok, bridge_pid}= create_bridge_worker(sup, ip_address)

    {:reply, {:ok, bridge_pid}, Map.put_new(state, ip_address, bridge_pid)}
  end

  # Private

  defp create_bridge_worker(sup, ip_address) do
    Supervisor.start_child(sup, [ip_address])
  end
end

