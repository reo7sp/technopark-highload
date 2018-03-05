defmodule Park.Server
  def start(port, file_root) do
    {:ok, server_socket} = :gen_tcp.accept(port, [:binary, packet: :line])
    loop(server_socket, [file_root: file_root])
  end

  defp loop(server_socket, opts) do
    {:ok, socket} = :gen_tcp.accept(server_socket)
    {:ok, pid} = Task.Supervisor.start_child(Park.Server.TaskSupervisor, fn -> serve(socket, opts) end)
    :ok = :gen_tcp.controlling_process(socket, pid)

    loop(server_socket)
  end

  defp serve(socket, opts) do
    {:ok, line} = :gen_tcp.recv(socket, 0)
    {method, path} = Park.RequestParser.parse_first_line(line)
    processed_params = Park.RequestParser.check(method, path)

    Path.Handler.handle(socket, processed_params)

    :gen_tcp.close(socket)
  end
end