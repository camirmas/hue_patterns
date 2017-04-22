defmodule PatternsControl.Bridge do
  use GenServer

  # API

  def start_link(ip_address) do
    GenServer.start_link(__MODULE__, ip_address)
  end

  def connect(pid) do
    GenServer.call(pid, :connect)
  end

  def get_info(pid) do
    GenServer.call(pid, :get_info)
  end

  # Callbacks

  def init(ip_address) do
    {:ok, %{bridge: nil, ip_address: ip_address}}
  end

  def handle_call(:connect, _from, %{ip_address: ip_address,
    bridge: nil} = state) do
      case _connect(ip_address) do
        %Huex.Bridge{status: :ok} = bridge ->
          {:reply, :ok, %{state | bridge: bridge}}
        %Huex.Bridge{status: :error, error: %{"description" => description}} ->
          {:reply, {:error, description}, state}
      end
  end

  def handle_call(:connect, _from, %{ip_address: ip_address,
    bridge: bridge} = state) do
      %Huex.Bridge{status: :ok} = bridge = _reconnect(ip_address, bridge.username)

      {:reply, :ok, %{state | bridge: bridge}}
  end

  def handle_call(:get_info, _from, %{bridge: bridge} = state) do
    {:reply, bridge, state}
  end

  # Private

  defp _connect(ip_address) when is_binary(ip_address) do
    Huex.connect(ip_address)
    |> Huex.authorize("hue-patterns#goku")
  end

  defp _reconnect(ip_address, username) when
    is_binary(ip_address) and is_binary(username) do
      Huex.connect(ip_address, username)
  end

  defp _create_light_workers(bridge) do
    bridge
    |> Huex.lights
    |> Enum.each(_create_light_worker)

    {:ok, []}
  end
end
