defmodule ExperimentWeb.PageController do
  use ExperimentWeb, :controller

  def index(conn, _params) do
    # raise "oops"
    values = ["one", "two", 3]
    tasks = Task.async_stream(values, fn(x) -> "text" <> x end)
    result = Enum.to_list(tasks)
    render(conn, "index.html")
  end
end
