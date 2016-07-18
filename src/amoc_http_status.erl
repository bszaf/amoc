-module(amoc_http_status).

-export([init/2, known_methods/2, allowed_methods/2, content_types_provided/2]).

-export([status_to_json/2, status_to_text/2]).

init(Req, Opts) ->
	{cowboy_rest, Req, Opts}.

known_methods(Req, Opts) ->
	{[<<"GET">>, <<"OPTIONS">>], Req, Opts}. %%TODO: Implement POST for solutions

allowed_methods(Req, Opts) ->
	{[<<"GET">>, <<"OPTIONS">>], Req, Opts}. %%TODO: Implement POST for solutions

content_types_provided(Req, Opts) ->
	{[{<<"application/json">>, status_to_json},
	  {<<"text/plain">>, status_to_text}
    ], Req, Opts}.

status_to_json(Req, Opts) ->
	Status = get_status(),
	Response = "{\"status\":" ++ atom_to_list(Status) ++ "}",
	{list_to_binary(Response), Req, Opts}.

status_to_text(Req, Opts) ->
	Status = get_status(),
	Response = list_to_binary(atom_to_list(Status)),
	{Response, Req, Opts}.

get_status() ->
	Results = application:which_applications(),
	Res = lists:keyfind(amoc, 1, Results),
	lager:info("Results: ~p", [Res]),
	case Res of
		{amoc, _Desc, _Vsn} -> 
			true;
		false ->
			false
	end.


