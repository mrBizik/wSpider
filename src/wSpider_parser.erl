%парсер ссылок
-module(wSpider_parser).

-export([extract_links/2, find_tag/2]).

% Выбор ссылок из DOM дерева
extract_links(Tree, Site_addres)->
  io:format("Extracting~n"),
  Site_addres.

find_tag(DOM_tree, Tag) -> 
	io:format("find_tag~n"),
	case {is_tuple(DOM_tree), is_list(DOM_tree)} of
		{true, false} -> 
			{Tag_name, Attributes, InHTML} = DOM_tree,
			io:format("Tag -> ~s~n", [Tag_name]),
			%find_tag(InHTML, Tag);
			if 
				Tag_name == Tag ->
					io:format("founded~n"),
					DOM_tree;
				true ->	
					find_tag(InHTML, Tag)
			end;
		{false, true} -> 
			parse_list(DOM_tree, Tag);

		{false, false} -> 
			io:format("~s~n", [DOM_tree]),
			null
	end.


parse_list(Tag_list, Tag)->
	if
		Tag_list =/= [] ->
			[Head|Tail] = Tag_list,
			io:format("parse_list~n"),
			find_tag(Head, Tag),
			case {Tail =/= []} of
				{true} -> parse_list(Tail, Tag);
				{false} -> null
			end;

		true -> null
	end.