%%%-------------------------------------------------------------------
%%% @author bizik
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. авг 2015 22:49
%%%-------------------------------------------------------------------
-module(wspider_url_downloader).
-author("bizik").

-behaviour(supervisor).

-export([init/1]).

-export([start_link/0, load_page/2]).

start_link() ->
  supervisor:start_link({global, ?MODULE}, ?MODULE, []).

init([]) ->
  {ok, {{one_for_one, 5, 10}, []}}.

load_page(Url, Callback) ->
  supervisor:start_child(
    {global, ?MODULE},
    {
      load_page, {?MODULE, grab_page, [Url, Callback]},
      permanent,
      2000,
      worker,
      []
    }
  ).

grab_page(Url, Callback) ->
  case wspider_grab:start(Url) of
    {ok, Result} -> Callback(Result);
    {failed, Result} -> {failed, Result}
  end.
