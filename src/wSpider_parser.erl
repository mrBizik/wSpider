%парсер ссылок
-module(wSpider_parser).

-export([extract_links/2, find_tag/3, find_attr/2]).

% Выбор ссылок из DOM дерева
extract_links(Tree, Site_addres)->
  io:format("Extracting~n"),
  Site_addres.


% поиск тэга и его поддерева
find_tag(DOM_tree, Tag, Parrent) when is_tuple(DOM_tree) -> 
	%io:format("Tag -> ~s~n", [Tag_name]),
	case DOM_tree of
		{comment, _Str} -> 
			%io:format("is comment~n"),
			Parrent;
		{Tag_name, _Attributes, InHTML} ->
		%io:format("Tag -> ~s~n", [Tag_name]),
		if 
			Tag_name == Tag ->
				%io:format("founded~n"),
				{ok, find_attr(DOM_tree, <<"href">>)};
    			%{ok, DOM_tree};
			true ->	
				find_tag(InHTML, Tag, DOM_tree) %!!!
		end
	end;
	

find_tag(DOM_tree, Tag, Parrent) when is_list(DOM_tree) and (DOM_tree == []) -> 
	%io: format("clear list~n"),
	Parrent;

find_tag(DOM_tree, Tag, Parrent) when is_list(DOM_tree)->
	[Head|Tail] = DOM_tree,
	%io:format("parse_tag_list~n~n"),
	find_tag(Head, Tag, Parrent),
	find_tag(Tail, Tag, Parrent);

find_tag(DOM_tree, Tag, Parrent) when is_binary(DOM_tree) ->
	%io:format("is binary~n"),
	Parrent.	


% поиск атрибута по имени
find_attr(Tag, Attr) when is_tuple(Tag) ->
	{Tag_name, Attributes, InHTML} = Tag,
	%io: format("find_attr~n"),
	find_attr(Attributes, Attr);


find_attr([], Attr) -> {ok, null};
find_attr(Attr_list, Attr) when is_list(Attr_list) ->
	[Head|Tail] = Attr_list,
	{Attr_name, Attr_value} = Head,
	%io:format("Attr ~s -> ~s ~n", [Attr_name, Attr_value]),
	if
		Attr_name == Attr ->
			io:format("founded -> ~s~n", [Attr_value]),
			{ok, Head};
		true ->
			find_attr(Tail, Attr)
	end.
		
