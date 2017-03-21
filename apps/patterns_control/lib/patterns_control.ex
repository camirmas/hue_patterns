defmodule PatternsControl do
  @moduledoc """
  Documentation for PatternsControl.
  """

  @doc """
  Hello world.

  ## Examples

      iex> PatternsControl.hello
      :world

  """
  def hello do
    :world
  end

  @doc """
  Connects to the Hue bridge and sets up workers for lights
  """
  def connect(ip_address) when is_binary(ip_address) do
    PatternsControl.Connector.connect(ip_address)
  end
end
