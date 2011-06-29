Definitions.

Digit = [0-9].
Letter = [a-zA-Z].

Rules.

%% Numbers
-?{Digit}+\.{Digit}+ : build_float(TokenChars, TokenLine).
-?{Digit}+ : build_int(TokenChars, TokenLine).

%% Symbols
{Letter}+ : build_symbol(TokenChars, TokenLine).

Erlang code.

build_float(Chars, Line) ->
	{token, {nil, nil}}.
	
build_int(Chars, Line) ->
    {token, {nil, nil}}.
    
build_symbol(Chars, Line) ->
    {token, {nil, nil}}.