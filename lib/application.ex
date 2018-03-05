defmodule Park.Application do
  use Application

  @port 80
  @file_root "/Users/reo7sp/m/code/technopark-highload/data"

  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Park.Server.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> Park.Server.start(@port, @file_root) end}, restart: :permanent)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
