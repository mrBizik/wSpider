%%%-------------------------------------------------------------------
%%% @author bizik
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. авг 2015 22:49
%%%-------------------------------------------------------------------
-module(wspider_logs).
-author("bizik").

%% API
-export([print/2]).

print(Format_str, Params) ->
  io:format(Format_str, [Params]).
