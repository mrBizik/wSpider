% Обработчик URL строк
-module(wSpider_url).

-export([parse/1]).


% Парсер URL строки
% @param Url 
% @return cortage - {Протокол, Домен, Путь, GET параметры, Якорь}
parse(Url)->
  Url_list = string:tokens(Url, "/:?#"),
  Url_list.