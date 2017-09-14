//
//  Copyright (C) 2010-2017  Denis Gavrish, Maximilian Diedrich
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

lexer grammar vhdl_lexer;

ABS: A B S;
ACCESS : A C C E S S;
ACROSS : A C R O S S;
AFTER : A F T E R;
ALIAS : A L I A S;
ALL : A L L;
AND : A N D;
ARCHITECTURE : A R C H I T E C T U R E;
ARRAY : A R R A Y;
ASSERT : A S S E R T;
ATTRIBUTE : A T T R I B U T E;
BEGIN : B E G I N;
BLOCK : B L O C K;
BODY : B O D Y;
BREAK : B R E A K;
BUFFER : B U F F E R;
BUS : B U S;
CASE : C A S E;
COMPONENT : C O M P O N E N T;
CONFIGURATION : C O N F I G U R A T I O N;
CONSTANT : C O N S T A N T;
DISCONNECT : D I S C O N N E C T;
DOWNTO : D O W N T O;
END : E N D;
ENTITY : E N T I T Y;
ELSE : E L S E;
ELSIF : E L S I F;
EXIT : E X I T;
FILE : F I L E;
FOR : F O R;
FUNCTION : F U N C T I O N;
GENERATE : G E N E R A T E;
GENERIC : G E N E R I C;
GROUP : G R O U P;
GUARDED : G U A R D E D;
IF : I F;
IMPURE : I M P U R E;
IN : I N;
INERTIAL : I N E R T I A L;
INOUT : I N O U T;
IS : I S;
LABEL : L A B E L;
LIBRARY : L I B R A R Y;
LIMIT : L I M I T;
LINKAGE : L I N K A G E;
LITERAL : L I T E R A L;
LOOP : L O O P;
MAP : M A P;
MOD : M O D;
NAND : N A N D;
NATURE : N A T U R E;
NEW : N E W;
NEXT : N E X T;
NOISE : N O I S E;
NOR : N O R;
NOT : N O T;
NULL : N U L L;
OF : O F;
ON : O N;
OPEN : O P E N;
OR : O R;
OTHERS : O T H E R S;
OUT : O U T;
PACKAGE : P A C K A G E;
PORT : P O R T;
POSTPONED : P O S T P O N E D;
PROCESS : P R O C E S S;
PROCEDURE : P R O C E D  U R E;
PROCEDURAL : P R O C E D U R A L;
PURE : P U R E;
QUANTITY : Q U A N T I T Y;
RANGE : R A N G E;
REVERSE_RANGE : R E V E R S E '_' R A N G E;
REJECT : R E J E C T;
REM : R E M;
RECORD : R E C O R D;
REFERENCE : R E F E R E N C E;
REGISTER : R E G I S T E R;
REPORT : R E P O R T;
RETURN : R E T U R N;
ROL : R O L;
ROR : R O R;
SELECT : S E L E C T;
SEVERITY : S E V E R I T Y;
SHARED : S H A R E D;
SIGNAL : S I G N A L;
SLA : S L A;
SLL : S L L;
SPECTRUM : S P E C T R U M;
SRA : S R A;
SRL : S R L;
SUBNATURE : S U B N A T U R E;
SUBTYPE : S U B T Y P E;
TERMINAL : T E R M I N A L;
THEN : T H E N;
THROUGH : T H R O U G H;
TO : T O;
TOLERANCE : T O L E R A N C E;
TRANSPORT : T R A N S P O R T;
TYPE : T Y P E;
UNAFFECTED : U N A F F E C T E D;
UNITS : U N I T S;
UNTIL : U N T I L;
USE : U S E;
VARIABLE : V A R I A B L E;
WAIT : W A I T;
WITH : W I T H;
WHEN : W H E N;
WHILE : W H I L E;
XNOR : X N O R;
XOR : X O R;

// case insensitive chars
fragment A:('a'|'A');
fragment B:('b'|'B');
fragment C:('c'|'C');
fragment D:('d'|'D');
fragment E:('e'|'E');
fragment F:('f'|'F');
fragment G:('g'|'G');
fragment H:('h'|'H');
fragment I:('i'|'I');
fragment J:('j'|'J');
fragment K:('k'|'K');
fragment L:('l'|'L');
fragment M:('m'|'M');
fragment N:('n'|'N');
fragment O:('o'|'O');
fragment P:('p'|'P');
fragment Q:('q'|'Q');
fragment R:('r'|'R');
fragment S:('s'|'S');
fragment T:('t'|'T');
fragment U:('u'|'U');
fragment V:('v'|'V');
fragment W:('w'|'W');
fragment X:('x'|'X');
fragment Y:('y'|'Y');
fragment Z:('z'|'Z');

//------------------------------------------Lexer-----------------------------------------
BASE_LITERAL
// INTEGER must be checked to be between and including 2 and 16 (included) i.e.
// INTEGER >=2 and INTEGER <=16
// A Based integer (a number without a . such as 3) should not have a negative exponent
// A Based fractional number with a . i.e. 3.0 may have a negative exponent
// These should be checked in the Visitor/Listener whereby an appropriate error message
// should be given
   :  INTEGER '#' BASED_INTEGER ('.'BASED_INTEGER)? '#' (EXPONENT)?
   ;

BIT_STRING_LITERAL
  : BIT_STRING_LITERAL_BINARY
  | BIT_STRING_LITERAL_OCTAL
  | BIT_STRING_LITERAL_HEX
  ;

BIT_STRING_LITERAL_BINARY
    :   ('b'|'B') '"' ('1' | '0' | '_')+ '"'
    ;

BIT_STRING_LITERAL_OCTAL
    :   ('o'|'O') '"' ('7' |'6' |'5' |'4' |'3' |'2' |'1' | '0' | '_')+ '"'
    ;

BIT_STRING_LITERAL_HEX
    :   ('x'|'X') '"' ( 'f' |'e' |'d' |'c' |'b' |'a' | 'F' |'E' |'D' |'C' |'B' |'A' | '9' | '8' | '7' |'6' |'5' |'4' |'3' |'2' |'1' | '0' | '_')+ '"'
    ;

REAL_LITERAL
   :    INTEGER '.' INTEGER  ( EXPONENT )?;

BASIC_IDENTIFIER
   :   LETTER ( '_' ( LETTER | DIGIT ) | LETTER | DIGIT )*
   ;

EXTENDED_IDENTIFIER
  : '\\' ( 'a'..'z' | '0'..'9' | '&' | '\'' | '(' | ')'
    | '+' | ',' | '-' | '.' | '/' | ':' | ';' | '<' | '=' | '>' | '|'
    | ' ' | OTHER_SPECIAL_CHARACTER | '\\'
    | '#' | '[' | ']' | '_' )+ '\\'
  ;

LETTER
  :  'a'..'z' | 'A'..'Z'
  ;

fragment PRMODULE
  : P R M O D U L E
  ;

fragment NOT_PRMODULE
  : ~('P'|'p')
  | P ~('R'|'r')
  | P R ~('M'|'m')
  | P R M ~('O'|'o')
  | P R M O ~('D'|'d')
  | P R M O D ~('U'|'u')
  | P R M O D U ~('L'|'l')
  | P R M O D U L ~('E'|'e') 
  ;

PRCOMMENT
  : '--'  PRMODULE
  ;
  
COMMENT
  : '--' NOT_PRMODULE .*? [\r\n]
  -> skip
  ;

TAB
  : ( '\t' )+ -> skip
  ;

SPACE
  : ( ' ' )+ -> skip
  ;

NEWLINE
  : '\n' -> skip
  ;

CR
  : '\r' -> skip
  ;

CHARACTER_LITERAL
   : APOSTROPHE . APOSTROPHE
   ;

STRING_LITERAL
  : '"' (~('"'|'\n'|'\r') | '""')* '"'
  ;

OTHER_SPECIAL_CHARACTER
  : '!' | '$' | '%' | '@' | '?' | '^' | '`' | '{' | '}' | '~'
  | ' ' | 'Ў' | 'ў' | 'Ј' | '¤' | 'Ґ' | '¦' | '§'
  | 'Ё' | '©' | 'Є' | '«' | '¬' | '­' | '®' | 'Ї'
  | '°' | '±' | 'І' | 'і' | 'ґ' | 'µ' | '¶' | '·'
  | 'ё' | '№' | 'є' | '»' | 'ј' | 'Ѕ' | 'ѕ' | 'ї'
  | 'А' | 'Б' | 'В' | 'Г' | 'Д' | 'Е' | 'Ж' | 'З'
  | 'И' | 'Й' | 'К' | 'Л' | 'М' | 'Н' | 'О' | 'П'
  | 'Р' | 'С' | 'Т' | 'У' | 'Ф' | 'Х' | 'Ц' | 'Ч'
  | 'Ш' | 'Щ' | 'Ъ' | 'Ы' | 'Ь' | 'Э' | 'Ю' | 'Я'
  | 'а' | 'б' | 'в' | 'г' | 'д' | 'е' | 'ж' | 'з'
  | 'и' | 'й' | 'к' | 'л' | 'м' | 'н' | 'о' | 'п'
  | 'р' | 'с' | 'т' | 'у' | 'ф' | 'х' | 'ц' | 'ч'
  | 'ш' | 'щ' | 'ъ' | 'ы' | 'ь' | 'э' | 'ю' | 'я'
  ;


DOUBLESTAR    : '**'  ;
ASSIGN        : '=='  ;
LE            : '<='  ;
GE            : '>='  ;
ARROW         : '=>'  ;
NEQ           : '/='  ;
VARASGN       : ':='  ;
BOX           : '<>'  ;
DBLQUOTE      : '"'   ;
SEMI          : ';'   ;
COMMA         : ','   ;
AMPERSAND     : '&'   ;
LPAREN        : '('   ;
RPAREN        : ')'   ;
LBRACKET      : '['   ;
RBRACKET      : ']'   ;
COLON         : ':'   ;
MUL           : '*'   ;
DIV           : '/'   ;
PLUS          : '+'   ;
MINUS         : '-'   ;
LOWERTHAN     : '<'   ;
GREATERTHAN   : '>'   ;
EQ            : '='   ;
BAR           : '|'   ;
DOT           : '.'   ;
BACKSLASH     : '\\'  ;


EXPONENT
  :  ('E'|'e') ( '+' | '-' )? INTEGER
  ;


HEXDIGIT
    :	('A'..'F'|'a'..'f')
    ;


INTEGER
  :  DIGIT ( '_' | DIGIT )*
  ;

DIGIT
  :  '0'..'9'
  ;

BASED_INTEGER
  : EXTENDED_DIGIT ('_' | EXTENDED_DIGIT)*
  ;

EXTENDED_DIGIT
  : (DIGIT | LETTER)
  ;

APOSTROPHE
  : '\''
  ;