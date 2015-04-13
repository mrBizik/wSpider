% Обработчик URL строк
-module(wSpider_url).

-export([parse/1, get_domain/1]).


% Парсер URL строки
% @param Url 
% @return cortage - {Протокол, Домен, Путь, GET параметры, Якорь}
parse(Url)->
  Url_list = string:tokens(Url, "/:?#"),
  Url_list.


get_domain([Head|Tail], N)->
  if 
    N == 1 ->
      Head;
    N < 1 ->
      get_domain(Tail, N+1)
  end.

get_domain(Url_list)->
  get_domain(Url_list, 0).

