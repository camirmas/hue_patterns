defmodule PatternsControl.Bridge do
  use GenServer

  # API

  def start_link(ip_address) do
    GenServer.start_link(__MODULE__, ip_address)
  end

  def connect(pid) do
    GenServer.call(pid, :connect)
  end

  # Callbacks

  def init(ip_address) do
    {:ok, %{bridge: nil, ip_address: ip_address, light_workers: []}}
  end

  def handle_call(:connect, _from, %{ip_address: ip_address} = state) do
    bridge = _connect(ip_address)

    {:reply, bridge, %{state | bridge: bridge}}
  end

  # Private

  defp _connect(ip_address) do
    Huex.connect(ip_address)
    |> Huex.authorize("hue-patterns#goku")
    |> create_light_workers
  end

  defp create_light_workers(_bridge) do
    {:ok, []}
  end
end
