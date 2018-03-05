defmodule Park.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Park.Server.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> Park.Server.accept(4040) end}, restart: :permanent)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
