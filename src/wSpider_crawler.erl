%%%
% Паук для обхода сайта
%%%
-module(wSpider_crawler).

-export([start/1, start/2]).

start(Site_url)-> start(Site_url, defgrab).
start(Site_url, Grab_type)->
  case start_grab(Site_url, Grab_type) of
    {ok, Content} ->
      % Парсинг страницы
      io:format("Page ~s loaded:~n", [Site_url]), 
      extract_links(Content, Site_url);
    {failed} -> {error} 
  end.


% Запуск грабера
start_grab(Site_url, Grab_type) ->
  case Grab_type of
    defgrab ->
      Page = wSpider_defgrab:start(Site_url)
  end.


% Преобразование в DOM и выбор ссылок из содержимого страницы
extract_links(Content, Site_url)->
  Dom_tree = mochiweb_html:parse(Content),
  Domain = wSpider_url:get_domain(wSpider_url:parse(Site_url)),
  Result = wSpider_parser:find_tag(Dom_tree, <<"a">>, {}),
  Result.