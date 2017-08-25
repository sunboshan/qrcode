defmodule QRCode.Encode do
  @moduledoc """
  Data encoding in Byte Mode.
  """

  @byte_mode 0b0100
  @pad <<236, 17>>
  @capacity_l [0, 17, 32, 53, 78, 106, 134, 154]
  @ecc_l %{
    1 => 19,
    2 => 34,
    3 => 55,
    4 => 80,
    5 => 108,
    6 => 136,
    7 => 156,
  }

  @doc """
  Encode the binary.

  Example:
      iex> QRCode.Encode.encode("hello world!")
      {1, [0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1,
       0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1,
       0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1,
       1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0,
       0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1,
       1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0]}
  """
  @spec encode(binary) :: {integer, [0 | 1]}
  def encode(bin) do
    version = version(bin)
    encoded = [<<@byte_mode::4>>, <<byte_size(bin)>>, bin, <<0::4>>]
      |> Enum.flat_map(&bits/1)
      |> pad_bytes(version)
    {version, encoded}
  end

  @doc """
  Returns the lowest version for the given binary.

  Example:
      iex> QRCode.Encode.version("hello world!")
      1
  """
  @spec version(binary) :: integer
  def version(bin) do
    len = byte_size(bin)
    Enum.find_index(@capacity_l, &(&1 >= len))
  end

  @doc """
  Returns bits for any binary data.

  Example:
      iex> QRCode.Encode.bits(<<123, 4>>)
      [0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0]
  """
  @spec bits(bitstring) :: [0 | 1]
  def bits(bin) do
    for <<b::1 <- bin>>, do: b
  end

  defp pad_bytes(list, version) do
    n = @ecc_l[version] * 8 - length(list)
    Stream.cycle(bits(@pad))
    |> Stream.take(n)
    |> (&Enum.concat(list, &1)).()
  end
end
