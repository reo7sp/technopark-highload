defmodule Park.ResponseMaker do
  def make_error(error_code) do
    first_headers(error_code, error_code) ++ new_line |> Enum.join("\r\n")
  end

  def make_file_response(file_size, mime_type) do
    first_headers(200, "200") ++ file_headers(file_size, mime_type) ++ new_line |> Enum.join("\r\n")
  end

  defp first_headers(code, status) do
    start = "HTTP/1.1 #{code} #{status}"
    date = "Date: #{elem(Timex.format(Timex.now, "{RFC1123}"), 1)}"
    server = "Server: highload-corutines"
    connection = "Connection: Close"
    [start, date, server, connection]
  end

  defp file_headers(length, type) do
    content_length = "Content-Length: #{content_length}"
    content_type = "Content-Type: #{content_type}"
    [content_length, content_type]
  end

  defp new_line do
    ["", ""]
  end
end