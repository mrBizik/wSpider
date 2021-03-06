%%%-------------------------------------------------------------------
%%% @author bizik
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. авг 2015 22:49
%%%-------------------------------------------------------------------
-module(wspider_grab).
-author("bizik").

-export([start/1]).


% Загрузить страницу
% @param Url - url загружаемой страницы
%
start(Url) ->
  inets:start(),
  get_url_contents(Url).

% Загрузить страницу
get_url_contents(Url) -> get_url_contents(Url, 5).
get_url_contents(Url, 0) -> {failed, 0};
get_url_contents(Url, Max_failures) ->
  case httpc:request(Url) of
    {ok, {{_, Ret_code, _}, _, Result}} -> if
                                             Ret_code == 200; Ret_code == 201 ->
                                               wspider_logs:print("OK Grub ~s~n", [Url]),
                                               {ok, Result};
                                             Ret_code >= 500 ->
                                               % server error, retry
                                               wspider_logs:print("HTTP code ~p~n", [Ret_code]),
                                               timer:sleep(1000),
                                               get_url_contents(Url, Max_failures - 1);
                                             true ->
                                               % all other errors
                                               {failed, Result}
                                           end;
    {error, _Why} ->
      wspider_logs:print("failed request: ~s : ~w~n", [Url, _Why]),
      timer:sleep(1000),
      get_url_contents(Url, Max_failures - 1)
  end.