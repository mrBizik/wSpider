-module(stop_words).
-behaviour(gen_server).

-export([start/0, check/1, get_list/0, version/0]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

-define(VERSION, 0.01).


load_words(FileName) ->
	string:tokens(string:to_lower(files:read_file(FileName)), "\n").

start() ->
  	gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

check(Key) ->
  	gen_server:call({global, ?MODULE}, { check, Key }).

get_list() ->
	gen_server:call({global, ?MODULE}, { list }).

version() ->
  gen_server:call({global, ?MODULE}, { version }).


find_stop_word([], Word) -> false;
find_stop_word([Head | Tail], Word) ->
	if
		Word == Head ->
			ok;
		true -> 
			find_stop_word(Tail, Word)
	end.

init([]) ->
  	State = load_words("stop_words/stop_words"),
  	{ok, State}.


handle_call({ check, Key }, _From, State) ->
  	Resp = find_stop_word(State, Key),
  	{ reply, Resp, State };

handle_call({ list }, _From, State) ->
  	% Resp = dict:to_list(State),
  	{ reply, State, State };

handle_call({ version }, _From, State) ->
  	{ reply, ?VERSION, State };

handle_call(_Message, _From, State) ->
  	{ reply, invalid_command, State }.

handle_cast(_Message, State) -> { noreply, State }.

terminate(_Reason, _State) -> ok.