%% -*- coding: utf-8 -*-
%% Модуль для построения индекса признаков
-module(wCat_sign_index).

-export([scan_doc/2, read_file/1, to_words/1, calc_freq/1, print_result/2, print_result/1, print_result/0]).

% Разбить на признаки один текст
scan_doc(file, Doc_name) ->
	%Stop_words = string:tokens(string:to_lower(read_file("stop_words/stop_words")), "\n"),
	calc_freq(to_words(read_file(Doc_name)));

scan_doc(text, Doc_text) ->
	%Stop_words = string:tokens(string:to_lower(read_file("stop_words/stop_words")), "\n"),
	calc_freq(to_words(Doc_text)).	


read_file(Name) ->
    {ok, Device} = file:open(Name, read),
    lists:merge(read_file_each_line(Device, [])).

read_file_each_line(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), lists:reverse(Accum);
        Line -> read_file_each_line(Device, [Line | Accum])
    end.

to_words(Text) ->
	string:tokens(string:to_lower(Text), "<>/@#$%^&*()_+= ,?.!:;-\"\'\n\t\b").

calc_freq([]) -> ok;
calc_freq(Word_list) ->
	[Head | Tail] = Word_list,
	
	%case find_stop_word(Stop_words, Head) of
	case stop_words:check(Head) of
		false -> 
			wCat_sign_db:check_word(Head),
			calc_freq(Tail);
		ok ->
			calc_freq(Tail);
		true ->
			error
	end.

print_result([], N) -> ok;
print_result([Head | Tail], N) ->
	{Word, Freq} = Head,
	io:setopts([{encoding, utf8}]),
	if 
		Freq > N ->
			io:format("Слово: ~w Вероятность: ~w ~n", [Word, Freq]),
			print_result(Tail);

		true ->
			print_result(Tail)
	end.
	
print_result(N) ->
	print_result(wCat_sign_db:get_list(), N).

print_result() ->
	print_result(0).


