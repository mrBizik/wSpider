%%%
% парсер ссылок
%%%
-module(wSpider_parser).

-export([find_tag/4, find_attr/2]).

% Поиск тэга с веткой дерева и получение значения атрибура href для этого тэга
% @param DOM_tree		- mochiweb_html дерево
% @param Tag 			- имя нужного тэга
% @param Attr 			- имя нужного атрибута
% @param Parrnet = [] 	- родительская ветка, для старта должна быть равна []
% @return cortage 		- {ok, Attribute}
find_tag(DOM_tree, Tag, Attr, Parrent) when is_tuple(DOM_tree) ->  %% {{case_clause,{<<4 bytes>>,<<34 bytes>>}},[{wSpider_parser,find_tag,4,[{file,"src/wSpider_parser.erl"},{line,15}]},{wSpider_parser,find_tag,4,[{file,"src/wSpider_parser.erl"},{line,31}]},{wSpider_crawler,grab_page,2,[{file,"src/wSpider_crawler.
	case DOM_tree of
		{comment, _Str} -> 
			Parrent;
		{Tag_name, _Attributes, InHTML} ->
			if 
				Tag_name == Tag ->
    				{ok, find_attr(DOM_tree, Attr)};
				true ->	
					find_tag(InHTML, Tag, Attr, DOM_tree) %!!!
			end;
		{Str1, Str2} ->
			io:format("find_tag ошибка ~s => ~s~n", [Str1, Str2]),
			error;
		true -> 
			io:format("find_tag ошибка~n"),
			error
	end;
find_tag(DOM_tree, Tag, Attr, Parrent) when is_list(DOM_tree) and (DOM_tree == []) -> 
	%io:format("find_tag is_list and []~n"),
	Parrent;

find_tag(DOM_tree, Tag, Attr, Parrent) when is_list(DOM_tree)->
	%io:format("find_tag is_list~n"),
	[Head|Tail] = DOM_tree,
	find_tag(Head, Tag, Attr, Parrent),
	find_tag(Tail, Tag, Attr, Parrent);

find_tag(DOM_tree, Tag, Attr, Parrent) when is_binary(DOM_tree) ->
	%io:format("find_tag is_binary~n"),
	Parrent.	


% поиск атрибута по имени
% @param Tag 		- mochiweb_html кортеж тэга
% @param Att 		- имя атрибута
% @return cortage 	- {ok, Attribute}
find_attr(Tag, Attr) when is_tuple(Tag) ->
	{Tag_name, Attributes, InHTML} = Tag,
	find_attr(Attributes, Attr);

find_attr([], Attr) -> {ok, null};

find_attr(Attr_list, Attr) when is_list(Attr_list) ->
	[Head|Tail] = Attr_list,
	{Attr_name, Attr_value} = Head,
	if
		Attr_name == Attr ->
			wSpider_supervisor:start_scan(erlang:binary_to_list(Attr_value));
			%wSpider_db:check_link(erlang:binary_to_list(Attr_value)),
			%ok;
		true ->
			find_attr(Tail, Attr)
	end.
		
