-module(hive_server).

-behaviour(gen_server).

%% API
-export([eval/1, start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    io:format("~p starting...~n", [?MODULE]),
    {ok, []}.

handle_call({eval, Expression}, _From, State) ->
    {reply, eval(Expression), State}.


handle_cast(_Msg, State) ->
    {noreply, State}.


handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    io:format("~p stopping...~n", [?MODULE]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

map(F, [H | T]) ->
    [F(H) | map(F, T)];
    
map(_, []) ->
    [].
    
lisp_apply(Fun, [H|T]) ->
    apply(Fun, map(fun(X) -> eval({ok, X}) end, [H|T]));
    
lisp_apply(_, []) -> [].
    
read({ok, Expression}) ->
    read(Expression);
    
read({cons, E1, E2}) ->
    [read(E1), read(E2)];
    
read({operator, {Op, _}}) ->
    case Op of
        '+' ->
            fun(X) -> lists:foldl(fun(Y, Accum) -> Accum + Y end, 0, X) end;
        '-' ->
            fun([H|T]) -> lists:foldl(fun(Y, Accum) -> Accum - Y end, H, T) end;
        '*' ->
            fun(X) -> lists:foldl(fun(Y, Accum) -> Accum * Y end, 1, X) end;
        '/' ->
            fun([H|T]) -> lists:foldl(fun(Y, Accum) -> Accum / Y end, H, T) end
    end;
    
read({integer, _, Value}) ->
    Value;
    
read({float, _, Value}) ->
    Value;
    
read({symbol, _, Value}) ->
    Value;
    
read(nil) ->
    [];
    
read(String) ->
    {ok, read(hive_parser:parse(element(2,hive_scanner:string(String))))}.
    
eval({ok, [H|T]}) when is_function(H) ->
    lisp_apply(H, T);
    
eval({ok, [H|T]}) ->
    map(fun(X) -> eval({ok, X}) end, [H|T]);
    
eval({ok, []}) ->
    [];
    
eval({ok, Value}) ->
    Value;
           
eval(String) ->
    eval(read(String)).
    
%print(Result) ->
%    io:format("~p~n", [Result]).
    

% TODO: Replace this loop with a receive loop for distributed computations
%loop() ->
%    Expression = read("hive> "),
%    print(eval(Expression)),
%    loop().