defmodule Park.Utils do
  def remove_preceding_slash(path) do
    if String.first(path) == "/" do
      String.slice(path, 1..-1)
    else
      path
    end
  end

  def remove_lasting_slash(path) do
    if String.last(path) == "/" do
      String.slice(path, 0..-2)
    else
      path
    end
  end
end