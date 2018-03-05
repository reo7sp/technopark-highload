defmodule Park.Handler do
  def handle(socket, {:ok, :HEAD, path}, opts) do
    file_path = "#{opts[:file_root]}/#{path}"
    %{size: file_length} = File.stat!(file_path)
    mime_type = Park.Mime.detect(file_path)

    :gen_tcp.send(Park.ResponseMaker.make_file_response(file_length, mime_type))
  rescue
    Park.ResponseMaker.make_error(404)
  end

  def handle(socket, {:ok, :GET, path}, opts) do
    file_path = "#{opts[:file_root]}/#{path}"
    %{size: file_length} = File.stat!(file_path)
    mime_type = Park.Mime.detect(file_path)

    :gen_tcp.send(Park.ResponseMaker.make_file_response(file_length, mime_type))

    file_path |>
      File.stream!([], 16384) |> 
      Stream.each(fn (block) -> :gen_tcp.send(socket, block) end)
  rescue
    Park.ResponseMaker.make_error(404)
  end

  def handle(socket, {:error, :method}, _) do
    Park.ResponseMaker.make_error(405)
  end

  def handle(socket, {:error, :path}, _) do
    Park.ResponseMaker.make_error(404)
  end
end