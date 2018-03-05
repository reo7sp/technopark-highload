defmodule Park.Application do
  use Application

  def start(_type, _args) do
    config = Park.Config.parse("/etc/httpd.conf")

    children = [
      {Task.Supervisor, name: Park.Server.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> Park.Server.start(config) end}, restart: :permanent)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
