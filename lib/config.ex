defmodule Park.Config do
  def parse(path) do
    file = File.read!(path)
    strings = file |> String.split("\n")
    config_lines = for string <- strings, do: string |> String.split()

    config = for line <- config_lines, Enum.at(line, 0) != nil, into: %{}, do: { String.to_atom(Enum.at(line, 0)), Enum.at(line, 1) }

    IO.write("Config: ")
    IO.inspect(config)

    config
  end
end