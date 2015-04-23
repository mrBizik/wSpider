%%%
% функции для работы с базой паука
%%%
-module(wSpider_db).
-behaviour(gen_server).

-export([start/0, check_link/1, set_link/2, get_link/1, get_list/0, version/0]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

-define(VERSION, 0.01).


start() ->
  gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

check_link(Link) ->
	case get_link(Link) of
		{reply, {ok, Value}, _State} ->
			set_link(Link, Value+1),
			{isset, {Link, Value}};
		{reply, error, _State} ->
			set_link(Link, 0),
			{new, {Link, 0}};
    true ->
      {error, null}
	end.

set_link(Key, Value) ->
  	gen_server:call({global, ?MODULE}, { set, Key, Value }).

get_link(Key) ->
  	gen_server:call({global, ?MODULE}, { get, Key }).

get_list() ->
	gen_server:call({global, ?MODULE}, {list}).

version() ->
  gen_server:call({global, ?MODULE}, { version }).



init([]) ->
  	State = dict:new(),
  	{ok, State}.

handle_call({ set, Key, Value }, _From, State) ->
  	NewState = dict:store(Key, Value, State),
  	{ reply, ok, NewState };

handle_call({ get, Key }, _From, State) ->
  	Resp = dict:find(Key, State),
  	{ reply, Resp, State };

handle_call({ list }, _From, State) ->
  	Resp = dict:to_list(State),
  	{ reply, Resp, State };

handle_call({ version }, _From, State) ->
  	{ reply, ?VERSION, State };

handle_call(_Message, _From, State) ->
  	{ reply, invalid_command, State }.

handle_cast(_Message, State) -> { noreply, State }.

terminate(_Reason, _State) -> ok.