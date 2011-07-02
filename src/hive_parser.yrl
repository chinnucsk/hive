Nonterminals s_expressions s_expression sym operator list.

Terminals '(' ')' '.' 'symbol' 'integer' 'float' '+' '-' '*' '/' '%' '!' '?'.

Rootsymbol s_expression.

s_expressions -> s_expression : {cons, '$1', nil}.
s_expressions -> s_expression s_expressions : {cons, '$1', '$2'}.

s_expression -> sym : '$1'.
s_expression -> '(' s_expression '.' s_expression ')' : {cons, '$2', '$3'}.
s_expression -> list : '$1'.

list -> '('')' : nil.
list -> '(' s_expressions ')' : '$2'.

sym -> symbol : '$1'.
sym -> integer : '$1'.
sym -> float : '$1'.
sym -> operator : '$1'.

operator -> '+' : {operator, '$1'}.
operator -> '-' : {operator, '$1'}.
operator -> '*' : {operator, '$1'}.
operator -> '/' : {operator, '$1'}.
operator -> '%' : {operator, '$1'}.
operator -> '!' : {operator, '$1'}.
operator -> '?' : {operator, '$1'}.