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
  def encode(binary) when byte_size(binary) <= 154 do
    data = QRCode.Encode.encode(binary)
      |> QRCode.ReedSolomon.encode()
    QRCode.Encode.version(binary)
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
  def encode(_) do
    IO.puts "Binary too long."
  end

  defdelegate render(matrix), to: QRCode.Render
end
