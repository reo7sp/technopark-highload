defmodule Park.Mime do
  def detect(path) do
    case extentsion(path) do
      "htm"  -> "text/html"
      "html" -> "text/html"
      "txt"  -> "text/plain"
      "css"  -> "text/css"
      "js"   -> "application/javascript"
      "gif"  -> "image/gif"
      "jpeg" -> "image/jpeg"
      "jpg"  -> "image/jpeg"
      "png"  -> "image/png"
      "swf"  -> "application/x-shockwave-flash"
    end
  end

  defp extentsion(path) do
    path |> String.split(".", parts: 2) |> List.last
  end
end