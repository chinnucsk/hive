Definitions.

Digit = [0-9]
Letter = [a-zA-Z]
Alphanumeric = [0-9a-zA-Z_\-]
Whitespace = [\s]
Comment = ;.*

Rules.

%% Numbers
-?{Digit}+\.{Digit}+ : build_float(TokenChars, TokenLine).
-?{Digit}+ : build_int(TokenChars, TokenLine).

%% Symbols
{Letter}+{Alphanumeric}* : build_symbol(TokenChars, TokenLine).
%'{Alphanumeric}+ : build_symbol(TokenChars, TokenLine, quoted).
%\'[^\s]+ : build_symbol(TokenChars, TokenLine, quoted).

%% Ignore
{Comment} : skip_token.
{Whitespace}+ : skip_token.

%% Misc

\(  : {token, {'(', TokenLine}}.
\)  : {token, {')', TokenLine}}.
\+  : {token, {'+', TokenLine}}.
-   : {token, {'-', TokenLine}}.
\*  : {token, {'*', TokenLine}}.
/   : {token, {'/', TokenLine}}.
\%  : {token, {'%', TokenLine}}.
!   : {token, {'!', TokenLine}}.
\?  : {token, {'?', TokenLine}}.


Erlang code.

build_float(Chars, Line) ->
	{token, {float, Line, list_to_float(Chars)}}.
	
build_int(Chars, Line) ->
    {token, {integer, Line, list_to_integer(Chars)}}.
    
build_symbol(Chars, Line) ->
    {token, {symbol, Line, Chars}}.
    
%build_symbol([_|T], Line, quoted) ->
%    {token, {symbol, Line, parse_symbol(T)}}.

%is_whitespace(Char) ->
%    case re:run(Char, "\\s+", []) of
%        {match, _} -> true;
%        {nomatch, _} -> false
%    end.
    
%parse_symbol([H|T]) ->
%    parse_symbol([H|T], 0, "(quote ").
    
%parse_symbol([H|T], Level, Accum) ->
%    case H of
%        '(' ->
%            parse_symbol(T, Level + 1, [H|Accum]);
%        ')' when (Level == 1) ->
%            parse_symbol([], Level, [H|Accum]);
%        ')' ->
%            parse_symbol(T, Level - 1, [H|Accum]);
%        _   ->
%            parse_symbol(T, Level, [H|Accum])
%    end;
    
%parse_symbol([], _, Accum) ->
%    lists:reverse(Accum).