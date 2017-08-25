defmodule QRCode.Render do
  @moduledoc """
  Render the QR Code matrix.
  """

  @doc """
  Render the QR Code to terminal.
  """
  @spec render(QRCode.Matrix.t) :: :ok
  def render(%QRCode.Matrix{matrix: matrix}) do
    Tuple.to_list(matrix)
    |> Enum.map_join("\n", fn e ->
      Tuple.to_list(e)
      |> Enum.map_join(&do_render/1)
    end)
    |> IO.puts()
  end

  defp do_render(1),         do: "\e[40m  \e[0m"
  defp do_render(0),         do: "\e[47m  \e[0m"
  defp do_render(nil),       do: "\e[46m  \e[0m"
  defp do_render(:reserved), do: "\e[44m  \e[0m"
end
