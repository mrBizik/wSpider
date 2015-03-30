-module(crawler).
-compile(export_all).

start(Target_url) ->
    	inets:start(),
    	io:format("start crawler~n"),
    	start_write(Target_url).
    	%end_write(Writer).

	
%%{Module, Function, Arguments} = Task,	
start_write(Target_url) ->
    	taskmanager:loadbalanser_create_thread({crawler, process_page,  Target_url}).	

end_write(WPid) ->
    	taskmanager:loadbalanser_thread_kill(WPid).

	
% Загрузка и разбиение по строкам страницы
process_page(Url) ->
	io:format("starting process_page~n"),
    	MyPid = self(),
    	case get_url_contents(Url) of
        	{ok, Data} ->
            		Strings = string:tokens(Data, "\n"),
			process_string(Strings);
%            		Pids = [spawn(fun() ->
%                          	process_string(W, MyPid, Url, Str)
%                          	end)  || Str <- Strings],
%            		collect(length(Pids));
        	_ -> end_write(MyPid)
    	end.
	

	
% Загрузить страницу
get_url_contents(Url) -> get_url_contents(Url, 5).
get_url_contents(Url, 0) -> failed;
get_url_contents(Url, MaxFailures) ->
  	case httpc:request(Url) of
    		{ok, {{_, RetCode, _}, _, Result}} -> if
      			RetCode == 200;RetCode == 201 ->
        			{ok, Result};
      			RetCode >= 500 ->
        			% server error, retry 
        			%io:format("HTTP code ~p~n", [RetCode]),
        			timer:sleep(1000),
        			get_url_contents(Url, MaxFailures-1);
      			true ->
        			% all other errors
        			failed
      			end;
    		{error, _Why} ->
      			io:format("failed request: ~s : ~w~n", [Url, _Why]), 
      			timer:sleep(1000),
      			get_url_contents(Url, MaxFailures-1)
  	end.

process_string(Str) ->
    case extract_link(Str) of
        {ok, Url} -> 
		io:format("~n~nNew URL: ~n~n"),	
		start_write(Url);
        failed    -> ok
    end.


% Регулярка для поиска ссылок
extract_link(S) ->
    	case re:run(S, "href *= *([^>]*)>", [{capture, all_but_first, list}]) of
        	{match, [Link]} -> {ok, string:strip(Link, both, $")};
        	_               -> failed
    	end.
	

