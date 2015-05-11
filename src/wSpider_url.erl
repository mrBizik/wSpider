%%%
% Обработчик URL строк
%%%
-module(wSpider_url).

-export([parse/1, link_type/1]).


% Парсер URL строки
% @param Url 
% @return cortage - {atom, {Протокол, Домен, Путь, GET параметры, Якорь}}
parse(Url)->
  Url_cortege = string:tokens(string:to_lower(Url), "/:?#"),
  Link_type = link_type(Url),
  {Link_type, Url_cortege}.


% Тип URL
% @param Url 
% @return atom - relative, anchor, absolute, other
link_type(Link) ->
  Relative = string:str(Link, "/"),
  Anchor = string:str(Link, "#"),
  Absolute_http = string:str(Link, "http://"),
  Absolute_https = string:str(Link, "https://"),
  if
    Relative == 1 -> relative;
    Anchor == 1 -> anchor;
    Absolute_http == 1 -> absolute;
    Absolute_https == 1 -> absolute;
    true -> other
  end.
