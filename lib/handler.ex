defmodule Park.Handler do
  @stream_buffer_size 128 * 1024

  def handle(socket, {:ok, :HEAD, path}, opts) do
    file_path = "#{opts[:document_root]}/#{path}"
    %{size: file_length} = File.stat!(file_path)
    mime_type = Park.Mime.detect(file_path)

    :gen_tcp.send(socket, Park.ResponseMaker.make_file_response(file_length, mime_type))
  rescue
    _ -> :gen_tcp.send(socket, Park.ResponseMaker.make_error(404))
  end

  def handle(socket, {:ok, :GET, path}, opts) do
    file_path = "#{opts[:document_root]}/#{path}"
    %{size: file_length} = File.stat!(file_path)
    mime_type = Park.Mime.detect(file_path)

    :gen_tcp.send(socket, Park.ResponseMaker.make_file_response(file_length, mime_type))

    file_path |>
      File.stream!([], @stream_buffer_size) |> 
      Stream.each(fn (block) -> :gen_tcp.send(socket, block) end) |>
      Stream.run
  rescue
    _ -> :gen_tcp.send(socket, Park.ResponseMaker.make_error(404))
  end

  def handle(socket, {:error, :method}, _) do
    :gen_tcp.send(socket, Park.ResponseMaker.make_error(405))
  end

  def handle(socket, {:error, :path}, _) do
    :gen_tcp.send(socket, Park.ResponseMaker.make_error(404))
  end
end