defmodule PatternsControl.BridgeServer do
  use GenServer

  # API

  def start_link(sup) do
    GenServer.start_link(__MODULE__, sup, name: __MODULE__)
  end

  def create_bridge(ip_address) do
    GenServer.call(__MODULE__, {:create_bridge, ip_address})
  end

  def get_bridges(ip_address) do
    GenServer.call(__MODULE__, {:get_bridges, ip_address})
  end

  def clear_bridges(ip_address) do
    GenServer.call(__MODULE__, {:clear_bridges, ip_address})
  end

  # Callbacks

  def init(sup) do
    bridges = :ets.new(:bridges, [])
    {:ok, %{sup: sup, bridges: bridges}}
  end

  def handle_call({:create_bridge, ip_address}, _from,
    %{sup: sup, bridges: bridges} = state) do
      bridge_pid = create_bridge(sup, ip_address, bridges)
      {:reply, {:ok, bridge_pid}, state}
  end

  def handle_call({:get_bridges, ip_address}, _from, %{bridges: bridges} = state) do
    case :ets.lookup(bridges, ip_address) do
      [{^ip_address, bridge_pids}] ->
        {:reply, bridge_pids, state}
      _ ->
        {:reply, [], state}
    end
  end

  def handle_call({:clear_bridges, ip_address}, _from, %{bridges: bridges} = state) do
    :ets.delete(bridges, ip_address)

    {:reply, :ok, state}
  end

  # Private

  defp create_bridge(sup, ip_address, bridges) do
    {:ok, pid} = Supervisor.start_child(sup, [ip_address])

    case :ets.lookup(bridges, ip_address) do
      [] ->
        :ets.insert(bridges, {ip_address, [pid]})
      [{^ip_address, pids}] ->
        :ets.insert(bridges, {ip_address, pids ++ [pid]})
    end

    #PatternsControl.Bridge.connect(pid)
    pid
  end
end
