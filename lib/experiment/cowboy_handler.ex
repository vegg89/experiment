defmodule Experiment.CowboyHandler do

  def init(stream_id, req, opts) do
    :cowboy_stream_h.init(stream_id, req, opts)
  end

  def data(stream_id, is_fin, data, state) do
    :cowboy_stream_h.data(stream_id, is_fin, data, state)
  end

  def info(stream_id, info = {:EXIT, pid, {reason, stacktrace}}, state) do
    commands0 = [{:internal_error, info, :"Stream process crashed"}]
    commands1 = case reason do
      (:normal) -> commands0
      (:shutdown) -> commands0
      ({:shutdown, _}) -> commands0
      _ ->
        [
          {
            :log,
            :error,
            'Ranch listener ~p, connection process ~p, stream ~p had its request process ~p exit with reason ~999999p and stacktrace ~999999p~n',
            [
              elem(state, 2),
              self(),
              stream_id,
              pid,
              reason,
              stacktrace
            ]
          }|commands0
        ]
      end
    response_command = {:error_response, 500, %{"x-header-reason" => "extra header"}, ""}
    {[response_command|commands1], state}
  end

  def info(stream_id, info, state) do
    :cowboy_stream_h.info(stream_id, info, state)
  end

  def terminate(stream_id, reason, state) do
    :cowboy_stream_h.terminate(stream_id, reason, state)
  end

  def early_error(stream_id, reason, partial_req, resp, opts) do
    :cowboy_stream_h.early_error(stream_id, reason, partial_req, resp, opts)
  end
end
