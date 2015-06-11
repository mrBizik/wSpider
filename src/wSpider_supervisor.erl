-module(wSpider_supervisor).
-behaviour(supervisor).

-export([start_link/0, init/1, start_scan/1, start_crawler/1, crawler/1, count/0]).

start_link() ->
  	supervisor:start_link({global, ?MODULE}, ?MODULE, []).

init([]) ->
  	{ok, {{one_for_one, 5, 10}, []}}.


start_scan(Url) ->
	supervisor:start_child(
		{global, ?MODULE}, 
		{crawler, {?MODULE, start_crawler, [Url]},
		permanent,
		2000,
		worker,
		[]}
    ).


start_crawler(Url) ->
	case wSpider_db:check_link(Url) of
		{isset, _Result} ->
			{ok, isset};
		{new, _Result} ->
			Pid = spawn_link(?MODULE, crawler, [Url]),
			io:format("Spawn PID ~w~s", [Pid]),
			{ok, Pid};
		{error, null} -> 
			 {error, null}
	end.


crawler(Url) ->
	io:format("start scaning ~s~n", [Url]),
	{ok, wSpider_crawler:scan_page(Url)}.

count() ->
	supervisor:count_children({global, ?MODULE}).