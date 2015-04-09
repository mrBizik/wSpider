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
      io:format("Page ~s loaded:~n ~s~n", [Site_url, Content]), 
      Dom_tree = mochiweb_html:parse(Content),
      io:format("Page ~s DOM:~n ~s~n", [Site_url, Dom_tree]), 
      Link_list = extract_links(Dom_tree, wSpider_url:parse(Site_url));
    {failed} -> Page 
  end.

% Выбор ссылок из DOM дерева
extract_links(Tree, Site_url)->
  io:format("Extracting~n").

