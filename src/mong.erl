-module(mong).

-export([start/0]).

-record(mydoc, {name, i}).
%-record(mydoc, {name, i, address}).
-record(address, {city, street, country}).


start() ->
	application:start(erlmongo),
	% Set mongodb server info. singleServer(PoolName) is the same as singleServer(PoolName,"localhost:27017")
	mongodb:singleServer(def),
	mongodb:connect(def),
	% Create an interface for test database (it has to be a binary)
	Mong = mongoapi:new(def,<<"test">>),
	%Mong:save(#mydoc{name = "zembedom", i = 10, address = #address{city = "ny", street = "some", country = "us"}}),
	%Mong:find(#mydoc{address = #address{city = "la"}}, undefined, 0, 0).
	% Save a new document
	%Mong:save(#mydoc{name = "MyDocument", i = 10}),
	% Return the document, but only the "i" field (+ _id which always gets returned)
	%Mong:findOne(#mydoc{i = 10}, [#mydoc.name]).
	%Mong:save("words", [{"word", "vasya"}, {"link", [{"a", 10}, {"b", 1}, {"c", 13}]}]),
	%Mong:findOne("words", [{"link.a", 10}], [{"word", 1}]).
	%Mong:save(#mydoc{name = "MyDocument", i = 10}).
	%Mong:save("words", [{"word", "vasya"}, {"link", [{"a", 10}, {"b", 1}, {"c", 13}]}]), % рабочий

	% find(Col, Query, Selector, From, Limit,{?MODULE,[Pool,DB]}) when is_list(Query)
	Mong:find("words", [{"link.a", 10}], [{"word", 1}, {"_id", 0}], 0, 10). % рабочий