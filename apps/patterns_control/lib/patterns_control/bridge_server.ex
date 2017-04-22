defmodule PatternsControl.BridgeServer do
  use GenServer

  alias PatternsControl.Bridge

  # API

  def start_link(sup) do
    GenServer.start_link(__MODULE__, sup, name: __MODULE__)
  end

  def create_bridge(ip_address, false) do
    GenServer.call(__MODULE__, {:create_bridge, ip_address})
  end

  def create_bridge(ip_address, _) do
    GenServer.call(__MODULE__, {:create_bridge_and_connect, ip_address})
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
      bridge_pid = _create_and_insert_bridge(sup, ip_address, bridges)
      {:reply, {:ok, bridge_pid}, state}
  end

  def handle_call({:create_bridge_and_connect, ip_address}, _from,
    %{sup: sup, bridges: bridges} = state) do
      bridge_pid = _create_bridge!(sup, ip_address)

      case Bridge.connect(bridge_pid) do
        :ok ->
          _insert_bridge(bridge_pid, ip_address, bridges)
          {:reply, {:ok, bridge_pid}, state}
        error ->
          Process.exit(bridge_pid, :shutdown)
          {:reply, error, state}
      end
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

  defp _insert_bridge(pid, ip_address, bridges) do
    case :ets.lookup(bridges, ip_address) do
      [] ->
        :ets.insert(bridges, {ip_address, [pid]})
      [{^ip_address, pids}] ->
        :ets.insert(bridges, {ip_address, pids ++ [pid]})
    end
    pid
  end

  defp _create_bridge!(sup, ip_address) do
    {:ok, pid} = Supervisor.start_child(sup, [ip_address])
    pid
  end

  defp _create_and_insert_bridge(sup, ip_address, bridges) do
    _create_bridge!(sup, ip_address)
    |> _insert_bridge(ip_address, bridges)
  end
end
