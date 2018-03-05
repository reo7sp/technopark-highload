require Logger

defmodule Park.Server do
  def start(config) do
    port = String.to_integer(config[:listen])
    {:ok, server_socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop(server_socket, config)
  end

  defp loop(server_socket, opts) do
    {:ok, socket} = :gen_tcp.accept(server_socket)
    {:ok, pid} = Task.Supervisor.start_child(Park.Server.TaskSupervisor, fn -> serve(socket, opts) end)
    :gen_tcp.controlling_process(socket, pid)

    loop(server_socket, opts)
  end

  defp serve(socket, opts) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, line} ->
        {method, path} = Park.RequestParser.parse_first_line(line)
        processed_params = Park.RequestParser.check(method, path)

        Park.Handler.handle(socket, processed_params, opts)

        :gen_tcp.close(socket)
      _ -> nil
    end
  end
end