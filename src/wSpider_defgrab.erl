%%%
% Дефолтный граббер страниц
%%%
-module(wSpider_defgrab).

-export([start/1]).


% Загрузить страницу
% @param Url - url загружаемой страницы
%
start(Url)->
	inets:start(),
  io:format("Grub ~s~n", [Url]),
	get_url_contents(Url).

% Загрузить страницу
get_url_contents(Url) -> get_url_contents(Url, 5).
get_url_contents(Url, 0) -> {failed};
get_url_contents(Url, Max_failures) ->
  	case httpc:request(Url) of
    		{ok, {{_, Ret_code, _}, _, Result}} -> if
      			Ret_code == 200; Ret_code == 201 ->
              io:format("OK Grub ~s~n", [Url]),
        			{ok, Result};
      			Ret_code >= 500 ->
        			% server error, retry 
        			io:format("HTTP code ~p~n", [Ret_code]),
        			timer:sleep(1000),
        			get_url_contents(Url, Max_failures-1);
      			true ->
        			% all other errors
        			{failed}
      			end;
    		{error, _Why} ->
      			io:format("failed request: ~s : ~w~n", [Url, _Why]), 
      			timer:sleep(1000),
      			get_url_contents(Url, Max_failures-1)
  	end.