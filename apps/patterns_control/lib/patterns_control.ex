defmodule PatternsControl do
  @moduledoc """
  Documentation for PatternsControl.
  """

  alias PatternsControl.Bridge
  alias PatternsControl.BridgeServer

  @doc """
  Attempts to connect to the given Hue bridge.
  """
  def connect(pid) when is_pid(pid) do
    Bridge.connect(pid)
  end

  @doc """
  Creates a new bridge at the given IP Address.
  """
  def create_bridge(ip_address, connect \\ true) do
    BridgeServer.create_bridge(ip_address, connect)
  end

  @doc """
  Gets all bridges associated with the given IP Address.
  """
  def get_bridges(ip_address) when is_binary(ip_address) do
    BridgeServer.get_bridges(ip_address)
  end

  @doc """
  Gets info for a Bridge given its pid.
  """
  def get_bridge(pid) when is_pid(pid) do
    Bridge.get_info(pid)
  end

  @doc """
  Removes all bridges associated with the given IP Address.
  """
  def clear_bridges(ip_address) when is_binary(ip_address) do
    BridgeServer.clear_bridges(ip_address)
  end
end
