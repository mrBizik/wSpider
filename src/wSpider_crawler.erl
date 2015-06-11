%%%
% Паук для обхода сайта
%%%
-module(wSpider_crawler).

-export([load_mod/0, start/1, scan_page/2, scan_page/1]).

load_mod() ->
  wSpider_db:start(),
  wCat_sign_db:start(),
  stop_words:start(),
  %rr("erlmongo.hrl"),
  application:start(erlmongo),
  mongodb:singleServer(def),
  mongodb:connect(def).

start(Site_url) -> 
  wSpider_db:set_domain(Site_url),
  scan_page(Site_url, defgrab).

scan_page(Page_url) -> scan_page(Page_url, defgrab).

scan_page(Page_url, Grab_type) when is_list(Page_url) ->
  %io:format("~n====================~nscan_page ~s~n", [Page_url]),
  {ok, Domain} = wSpider_db:get_domain(),

  case wSpider_url:link_type(Page_url) of
    relative -> 
     %io:format("relative ~s~n", [Page_url]),
     grab_page(string:concat(Domain, Page_url), Grab_type);

    absolute -> 
      %io:format("absolute ~s~n", [Page_url]),
      case wSpider_db:check_domain(Page_url) of 
        {ok, _Url} -> grab_page(Page_url, Grab_type);
        {error, _Url} -> error
      end;

    anchor -> 
     % io:format("anchor ~s~n", [Page_url]),
      %io:format("Domain ~p~n", [Domain]),
      grab_page(string:join(Domain, Page_url, "/"), Grab_type);

    other -> error;

    true -> error
  end.

grab_page(Page_url, Grab_type) ->
  case start_grab(Page_url, Grab_type) of
    {ok, Content} ->
      % Парсинг страницы
      io:format("Page ~s loaded:~n", [Page_url]), 
      extract_links(Content),
      ok;
    {failed} -> error
  end.


% Запуск грабера
start_grab(Page_url, Grab_type) ->
  case Grab_type of
    defgrab ->
      wSpider_defgrab:start(Page_url)
  end.


% Преобразование в DOM и выбор ссылок из содержимого страницы
extract_links(Content) ->
  %io:format("Page Content:~w~n", [Content]), 
  Dom_tree = mochiweb_html:parse(Content),
  %io:format("Поиск атрибута"),
  Result = wSpider_parser:find_tag(Dom_tree, <<"a">>, <<"href">>, {}),
  Result.