-module(wSpider_start).
-export([start/2, start/1, start/0, stop/0]).

start() ->
	io:format("*********************************************************~n"),
	io:format("*                                                       *~n"),
	io:format("*             wSpider (early alfa :D)                   *~n"),
	io:format("*                                                       *~n"),
	io:format("*********************************************************~n"),	
	io:format("start(Target) ==>~n starting crawling Target web resourse~n"),
	io:format("start(Target, [Task_list]) ==>~n starting crawling Target web resourse and starting tasks~n"),
	io:format("*********************************************************~n"),
	io:format("Task_list format ==>~n {Module, Function, Arguments},...,{Module, Function, Arguments}~n~n"),
	io:format("Module ==>~n Task~n~n Function ==>~n Starting function~n~n Arguments ==>~n Task parametrs~n"),
	io:format("*********************************************************~n").
		

start(Target) ->
	Node = server@debian,
	io:format("target: ~s~n", [Target]),
	% регистрируем балансировщик нагрузки
	register(loadbalanser, spawn(Node, wSpider_taskmanager, loadbalanser, [0])),
	%запускаем паука
	crawler:start(Target).

start(Target, Tasks) ->
	io:format("target: ~s~n", [Target]),
	
	% регистрируем балансировщик нагрузки
	register(loadbalanser, spawn(wSpider_taskmanager, loadbalanser, [0])),

	parse_args(Tasks).


stop() -> taskmanager:loadbalanser_stop().

% парсер аргументов
parse_args([]) -> io:format("end tasks.~n");
parse_args([Head | Tail]) when is_list([Head | Tail]) ->	
	% регистрируем новый таск
	{Module, Function, Arguments} = Head,
	io:format("task: ~s:~s(~w)~n", [Module, Function, Arguments]),
	register(Module ++ ":" ++ Function ,spawn(Module, Function, Arguments)),

	parse_args(Tail).



