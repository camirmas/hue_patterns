defmodule PatternsControl.Bridge do
  use GenServer

  # API

  def start_link(ip_address) do
    GenServer.start_link(__MODULE__, ip_address)
  end

  # Callbacks

  def init(ip_address) do
    {:ok, bridge} = connect(ip_address)
    {:ok, light_workers} = create_light_workers(bridge)

    {:ok, %{bridge: bridge, ip_address: ip_address, light_workers: light_workers}}
  end

  # Private

  defp connect(ip_address) when is_binary(ip_address) do
    Huex.connect(ip_address)
    |> Huex.authorize("hue-patterns#goku")
    |> create_light_workers
  end

  defp create_light_workers(_bridge) do
    {:ok, []}
  end
end
