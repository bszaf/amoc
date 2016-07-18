-module(amoc_http).
% TODO: Add tests
% TODO: Add specs

-behaviour(gen_server).

%% specific callbacks
-export([start_http_server/1]).

%% gen_server callbacks
-export([start_link/0, init/1, handle_cast/2, handle_call/3, terminate/2, handle_info/2, code_change/3]).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE,[], []).

% TODO: Add args
init(_Args) ->
	start_http_server(5678),
	{ok, []}.

%% gen_server callbacks
handle_call(_, _, State) ->
	{reply, ok, State}.

handle_cast(_, State) ->
	{noreply, State}.

% TODO: log termination
terminate(_Reason, _State) ->
	ok.

handle_info(_, State) ->
	{noreply, State}.

code_change(_, State, _) ->
	{ok, State}.

%% specific functions
start_http_server(PortNumber) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/status", amoc_http_status, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, 100, [{port, PortNumber}], #{
		env => #{dispatch => Dispatch}
	}),
	ok.				

