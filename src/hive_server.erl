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
    
lisp_apply(Op, [H | T]) ->
    case Op of
        '+' ->
            lists:foldl(fun(X, Accum) -> Accum + X end, 0, map(fun(X) -> eval({eval, X}) end, [H | T]));
        '-' ->
            lists:foldl(fun(X, Accum) -> Accum - X end, 0, map(fun(X) -> eval({eval, X}) end, [H | T]));
        '*' ->
            lists:foldl(fun(X, Accum) -> Accum * X end, 1, map(fun(X) -> eval({eval, X}) end, [H | T]));
        '/' ->
            lists:foldl(fun(X, Accum) -> Accum / X end, eval({eval, H}), map(fun(X) -> eval({eval, X}) end, T))
            
    end;
    
lisp_apply(_, []) -> [].

read(String) ->
    hive_parser:parse(element(2,hive_scanner:string(String))).
    
eval({ok, Expression}) ->
    eval(Expression);
    
eval({cons, E1, E2}) ->
    [eval(E1), eval(E2)];
    
eval({operator, {Op, Line}}) ->
    case Op of
        '+' ->
            fun(X, Accum) -> Accum + X end;
        '-' ->
            fun(X, Accum) -> Accum - X end;
        '*' ->
            fun(X, Accum) -> Accum * X end;
        '/' ->
            fun(X, Accum) -> Accum / X end
    end;
    
eval({integer, _, Value}) ->
    Value;
    
eval({float, _, Value}) ->
    Value;
    
eval({symbol, _, Value}) ->
    Value;
    
eval(nil) ->
    nil;
        
eval(String) ->
    print(eval(read(String))).
    
print(Result) ->
    io:format("~p~n", [Result]).
    

% TODO: Replace this loop with a receive loop for distributed computations
loop() ->
    Expression = read("hive> "),
    print(eval(Expression)),
    loop().