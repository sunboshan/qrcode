# QRCode

QR Code implementation in Elixir.

![demo](priv/demo.png)

Spec:
- Version: 1 - 7
- ECC level: L
- Encoding mode: Byte

References:
- ISO/IEC 18004:2006(E)
- http://www.thonky.com/qr-code-tutorial/

## Usage

```
$ iex -S mix
iex> QRCode.encode("https://www.google.com") |> QRCode.render()
iex> QRCode.encode("床前明月光，疑是地上霜，举头望明月，低头思故乡") |> QRCode.render()
iex> QRCode.encode("unicode support 😃") |> QRCode.render()
```
