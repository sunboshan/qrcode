defmodule QRCodeTest do
  use ExUnit.Case
  doctest QRCode.Encode
  doctest QRCode.ReedSolomon
  doctest QRCode.GaloisField
  doctest QRCode.Matrix
end
