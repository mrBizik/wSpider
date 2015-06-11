%%%
% функции для работы с базой паука
%%%
-module(wCat_sign_db).
-behaviour(gen_server).

-export([start/0, check_word/1, to_mongo/0, set_word/2, get_word/1, get_list/0, get_size/0, version/0]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

-define(VERSION, 0.01).


start() ->
  gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

check_word(Word) when is_list(Word) ->
  %Word_unicode = unicode:characters_to_list(Word),
  %io:format("Word_unicode = ~p~n", [Word]),
  Word_unicode = Word,
	case get_word(Word_unicode) of
		{ok, Value} ->
			set_word(Word_unicode, Value+1),
			{isset, {Word, Value}};
    error -> 
      set_word(Word_unicode, 1),
      {new, {Word_unicode, 1}};
    true ->
      {error, null}
	end;

check_word(Word) -> io:format("check_word Неверный тип данных аругмента Word~n").

%%%
% Загрузка инвертированного индекса
%%%

build_index(Mong, [], Domain) -> ok;
build_index(Mong, [Head | Tail], Domain) ->
  {Word, Freq} = Head,
  Mong:save("words", [{"word", Word}, {"link", Domain}, {"prob", Freq}]),
  build_index(Mong, Tail, Domain).


to_mongo() ->
  mongodb:singleServer(def),
  mongodb:connect(def),
  Mong = mongoapi:new(def,<<"test_word">>),
  %Mong:save("words", wCat_sign_db:get_list()).
  {_, Domain} =  wSpider_db:get_domain(),
  build_index(Mong, wCat_sign_db:get_list(), Domain).


  





set_word(Key, Value) ->
  	gen_server:call({global, ?MODULE}, { set, Key, Value }).

get_word(Key) ->
  	gen_server:call({global, ?MODULE}, { get, Key }).

get_list() ->
	gen_server:call({global, ?MODULE}, {list}).

get_size() ->
  gen_server:call({global, ?MODULE}, {count}).

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

handle_call({count}, _From, State) ->
    Resp = dict:size(State),
    { reply, Resp, State };

handle_call({ version }, _From, State) ->
  	{ reply, ?VERSION, State };

handle_call(_Message, _From, State) ->
  	{ reply, invalid_command, State }.

handle_cast(_Message, State) -> { noreply, State }.

terminate(_Reason, _State) -> ok.