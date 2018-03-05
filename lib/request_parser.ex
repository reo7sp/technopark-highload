defmodule Park.RequestParser do
  def parse_first_line(s) do
    case String.split(s) do
      [method, path, _protocol] -> {method, path}
      [] -> {"", ""}
    end
  end

  def check(method, path) do
    try do
      method_check = check_method(method)
      case method_check do
        :error -> throw {:error, :method}
        _ -> nil
      end
      {:ok, processed_method} = method_check

      path_check = check_path(path)
      case path_check do
        :error -> throw {:error, :path}
        _ -> nil
      end
      {:ok, processed_path} = path_check

      {:ok, processed_method, processed_path}
    catch
      it -> it
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
      true -> 
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