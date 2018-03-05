defmodule Park.RequestParser do
  def parse_first_line(s) do
    {method, path, protocol} = String.split(s)
    {method, path}
  end

  def check(method, path) do
    method_check = check_method(method)
    path_check = check_path(path)
    cond do
      :error = method_check -> {:error, :method}
      :error = path_check -> {:error, :path}
      _ -> 
        {:ok, processed_method} = method_check
        {:ok, processed_path} = path_check
        {:ok, processed_method, processed_path}
    end
  end

  defp check_method(method) do
    case method do
      "GET" -> {:ok, :GET}
      "HEAD" -> {:ok, :HEAD}
      _ -> :error
    end
  end

  defp check_path(path) do
    cond do
      String.contains?(path, "../") -> :error
      _ -> 
        decoded_path = path |> resolve_path_index |> URI.decode 
        {:ok, decoded_path}
    end
  end

  defp resolve_path_index(path) do
    if (path == "" || String.last(path) == "/") do
      "#{path}index.html"
    else
      path
    end
  end
end