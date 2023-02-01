grammar dae_config;

// Fragments
fragment SAFE_ID_HEAD_CHAR: [a-zA-Z_] ;
fragment SAFE_NONID_HEAD_CHAR: [/\\^*.+0-9-] ;
fragment SAFE_INTERMEDIATE_CHAR: [=@$!#%] ;
fragment SAFE_CHAR: ( SAFE_ID_HEAD_CHAR | SAFE_NONID_HEAD_CHAR | SAFE_INTERMEDIATE_CHAR ) ;
fragment DOUBLE_QUOTE_STRING : '"' ( '\\"' | . )*? '"' ; // match "foo", "\"", "x\"\"y", ...
fragment SINGLE_QUOTE_STRING : '\'' ( '\\\'' | . )*? '\'' ; // match 'foo', '\'', 'x\'\'y', ...

// Tokens
WHITESPACE : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines
COMMENT_BLOCK : '/*' .*? '*/' -> skip ;
COMMENT_LINE_SHARP : '#' .*? ( [\r\n]+ | EOF ) -> skip ;

ID : SAFE_ID_HEAD_CHAR SAFE_CHAR* ;
NON_ID : SAFE_NONID_HEAD_CHAR SAFE_CHAR* ;
QUOTE_STRING : DOUBLE_QUOTE_STRING | SINGLE_QUOTE_STRING ;

// Rules
start : input EOF;

bare_literal
    : ID | NON_ID
    ;

quote_literal
    :  QUOTE_STRING
    ;

literal
    : quote_literal
    | bare_literal
    ;

literalExpression
    : literal ',' literalExpression
    | literal
    ;

input
    : programStructureBlcok
    | input programStructureBlcok
    | // empty
    ;

programStructureBlcok
    : expression
    ;

expression
    : ID '{' routingRuleOrDeclarationOrLiteralOrExpressionList '}'
    ;

declaration
    : ID ':' functionPrototypeExpression
    | ID ':' literalExpression
    ;

functionPrototype
    : '!'? ID '(' optParameterList ')'
    ;

optParameterList
    : nonEmptyParameterList
    | // empty
    ;

nonEmptyParameterList
    : parameter
    | nonEmptyParameterList ',' parameter
    ;

parameter
    : ID ':' literal
    | literal
    ;

routingRule
    : functionPrototypeExpression '->' bare_literal
    ;


functionPrototypeExpression
    : functionPrototype
    | functionPrototype '&&' functionPrototypeExpression
    ;

routingRuleOrDeclarationOrLiteralOrExpressionList
    : routingRule routingRuleOrDeclarationOrLiteralOrExpressionList
    | declaration routingRuleOrDeclarationOrLiteralOrExpressionList
    | literal routingRuleOrDeclarationOrLiteralOrExpressionList
    | expression routingRuleOrDeclarationOrLiteralOrExpressionList
    | // empty
    ;

routingRuleList
    : routingRule
    | routingRule routingRuleList
    ;
