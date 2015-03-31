-module(wSpider_taskmanager).
-compile(export_all).
%-export([loadbalanser/1, loadbalanser_stop/0, loadbalanser_wait/0, loadbalanser_create_thread/1]).

% дефолтное макс. число потоков
get_max_thread() -> 10.

%послать сообщение балансировщику
loadbalanser_stop() -> loadbalanser ! stop. % остановить сканер
loadbalanser_wait() -> loadbalanser ! wait. % пауза(?)
loadbalanser_create_thread(Task) -> loadbalanser ! {new_thread, Task}. % запрос на создение нового потока
loadbalanser_thread_kill(Pid) -> loadbalanser ! {kill_thread, Pid}.    % сообщение от потока о его завершении


% балансировщик
loadbalanser(Threads) ->
	io:format("spawning loadbalanser ~p ~n", [Threads]),
	% здесь когда-нибудь будет какой-нибудь хитромудрый алгоритм балансировки нагрузки =)
	receive 
		% остановить сканирование
		stop -> io:format("stop scaning~n");

		% ожидать в очереди(?) 
		wait -> io:format("waiting queue~n"), loadbalanser(Threads);

		% создать новый поток
		{new_thread, Task} -> 
			io:format("try create new thread: "), 

			%if
				%Threads < 10 ->
					{Module, Function, Arguments} = Task,
					io:format("spawn ~p~n", [Function]),
					spawn(Module, Function, [Arguments]),
					io:format("success!~n"),
					loadbalanser(Threads+1);
			
				%true -> 
				%	timer:sleep(1000),
				%	loadbalanser(Threads)
				%	%loadbalanser_create_thread(Task)
			%end;			

		% поток Pid заверишл работу
		{kill_thread, Pid} ->
			io:format("kill thread~n"),
			loadbalanser(Threads-1)
	end.
		

