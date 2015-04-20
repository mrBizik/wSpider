% Паук для обхода сайта
-module(wSpider_crawler).

-export([start/1, start/2]).

start(Site_url)-> start(Site_url, defgrab).
start(Site_url, Grab_type)->
  case Grab_type of
    defgrab ->
      Page = wSpider_defgrab:start(Site_url)
  end,
  case Page of
    {ok, Content} ->
      % Парсинг страницы
      io:format("Page ~s loaded:~n", [Site_url]), 
      Dom_tree = mochiweb_html:parse(Content),
      Domain = wSpider_url:get_domain(wSpider_url:parse(Site_url)),
      %Link_list = wSpider_parser:extract_links(Dom_tree, Domain),
      %Dom_tree;
      Result = find(Dom_tree, <<"a">>),
      Result;
      %{_, {_ ,{Attr_name, Attr_value}}} = Result,
      %io:format("result ~s~n", [Attr_value]);
    {failed} -> Page 
  end.


find(Dom_tree, Tag) ->
  wSpider_parser:find_tag(Dom_tree, Tag, {}).


