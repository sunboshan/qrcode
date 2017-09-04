defmodule QRCode do
  @moduledoc """
  QR Code implementation in Elixir.

  Spec:
    - Version: 1 - 7
    - ECC level: L
    - Encoding mode: Byte

  References:
    - ISO/IEC 18004:2006(E)
    - http://www.thonky.com/qr-code-tutorial/
  """

  @doc """
  Encode the binary.
  """
  @spec encode(binary) :: QRCode.Matrix.t
  def encode(bin) when byte_size(bin) <= 154 do
    data = QRCode.Encode.encode(bin)
      |> QRCode.ReedSolomon.encode()

    QRCode.Encode.version(bin)
    |> QRCode.Matrix.new()
    |> QRCode.Matrix.draw_finder_patterns()
    |> QRCode.Matrix.draw_seperators()
    |> QRCode.Matrix.draw_alignment_patterns()
    |> QRCode.Matrix.draw_timing_patterns()
    |> QRCode.Matrix.draw_dark_module()
    |> QRCode.Matrix.draw_reserved_format_areas()
    |> QRCode.Matrix.draw_reserved_version_areas()
    |> QRCode.Matrix.draw_data_with_mask(data)
    |> QRCode.Matrix.draw_format_areas()
    |> QRCode.Matrix.draw_version_areas()
    |> QRCode.Matrix.draw_quite_zone()
  end
  def encode(_), do: IO.puts "Binary too long."

  @doc """
  Encode the binary with custom pattern bits. Only supports version 5.
  """
  @spec encode(binary, bitstring) :: QRCode.Matrix.t
  def encode(bin, bits) when byte_size(bin) <= 106 do
    data = QRCode.Encode.encode(bin, bits)
      |> QRCode.ReedSolomon.encode()

    QRCode.Matrix.new(5)
    |> QRCode.Matrix.draw_finder_patterns()
    |> QRCode.Matrix.draw_seperators()
    |> QRCode.Matrix.draw_alignment_patterns()
    |> QRCode.Matrix.draw_timing_patterns()
    |> QRCode.Matrix.draw_dark_module()
    |> QRCode.Matrix.draw_reserved_format_areas()
    |> QRCode.Matrix.draw_data_with_mask0(data)
    |> QRCode.Matrix.draw_format_areas()
    |> QRCode.Matrix.draw_quite_zone()
  end
  def encode(_, _), do: IO.puts "Binary too long."

  defdelegate render(matrix),  to: QRCode.Render
  defdelegate render2(matrix), to: QRCode.Render
end
