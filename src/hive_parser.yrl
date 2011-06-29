Nonterminals s_expressions s_expression symbol operator list.

Terminals '(' ')' '.' 'quote' 'atom' 'integer' 'float' '+' '-' '*' '/' '!'.

Rootsymbol s_expression.

s_expressions -> s_expression : {cons, '$1', nil}.
s_expressions -> s_expression s_expressions : {cons, '$1', '$2'}.

s_expression -> symbol : '$1'.
s_expression -> '(' s_expression '.' s_expression ')' : {cons, '$2', '$3'}.
s_expression -> list : '$1'.

list -> '('')' : nil.
list -> '(' s_expressions ')' : '$2'.

symbol -> quote symbol : '$2'.
symbol -> atom : '$1'.
symbol -> integer : '$1'.
symbol -> float : '$1'.
symbol -> operator: '$1'.

operator -> '+' : {operator, '$1'}.
operator -> '-' : {operator, '$1'}.
operator -> '*' : {operator, '$1'}.
operator -> '/' : {operator, '$1'}.
operator -> '!' : {operator, '$1'}.