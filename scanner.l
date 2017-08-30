%{
  #include <string.h>
  #include <stdio.h>
  #include <stdlib.h>

  // Reserved word type
  enum token_type{
    RESERVED_WORD,
    PUNCTUATION_TOKEN,
    RELATIONAL_TOKEN,
    ANL_OPERATOR,
    ASSIGNMENT_OPERATION,
    NUMBER,
    IDENTIFIER,
    COMMENT
  };

  // Array to get string value of token types
  const char* token_names[] = {
    "Reserved Word      ",
    "Punctuation Token  ",
    "Relational Token   ",
    "AnL Operators      ",
    "Assignment Operator",
    "Number             ",
    "Identifier         ",
    "Comment            "
  };

  // Create symbol struct
  typedef struct symbol {
    int *type;
    char *value;
  } symbol;

  symbol *symbol_table;

  // Create symbol table
  /*symbol *symbol_table = malloc(200 * sizeof(symbol_table));*/

  // Variables to get characters, words and lines
  int chars = 0;
  int words = 0;
  int lines = 0;
  int sIndex = 0;

  // Declare errors, functions and stuff
  void yyerror(char *string);
  void save(int, char *);
  void print_symboltable();
  int yyval;

%}

%%
[ \t] { }
[/]{2}.*[\n]			{ save(COMMENT, yytext); }
(\/\*[^*]*\*+(?:[^/*][^*]*\*+)*\/) { save(COMMENT, yytext); }
"int" { save(RESERVED_WORD, yytext); }
"float" { save(RESERVED_WORD, yytext); }
"if" { save(RESERVED_WORD, yytext); }
"then" { save(RESERVED_WORD, yytext); }
"else" { save(RESERVED_WORD, yytext); }
"while" { save(RESERVED_WORD, yytext); }
"read" { save(RESERVED_WORD, yytext); }
"write" { save(RESERVED_WORD, yytext); }
"+" { save(ANL_OPERATOR, yytext); }
"-" { save(ANL_OPERATOR, yytext); }
"*" { save(ANL_OPERATOR, yytext); }
"/" { save(ANL_OPERATOR, yytext); }
":=" { save(ASSIGNMENT_OPERATION, yytext); }
")" { save(PUNCTUATION_TOKEN, yytext); }
"(" { save(PUNCTUATION_TOKEN, yytext); }
"}" { save(PUNCTUATION_TOKEN, yytext); }
"{" { save(PUNCTUATION_TOKEN, yytext); }
"," { save(PUNCTUATION_TOKEN, yytext); }
";" { save(PUNCTUATION_TOKEN, yytext); }
"<=" { save(RELATIONAL_TOKEN, yytext); }
">=" { save(RELATIONAL_TOKEN, yytext); }
"!=" { save(RELATIONAL_TOKEN, yytext); }
"<" { save(RELATIONAL_TOKEN, yytext); }
">" { save(RELATIONAL_TOKEN, yytext); }
"=" { save(0, yytext); }
([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)? { save(NUMBER, yytext); }
[A-Za-z_][A-Za-z0-9_]* { save(IDENTIFIER, yytext); }
\n { chars++; lines++; }
. { chars++; printf("Unrecognized token: '%s'\n", yytext);  }
%%

/*printf("Unknown word: %s", yytext);*/

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  FILE *file_pointer;
  char character;

  // Allocate memory for symbol table
  symbol_table = (symbol *)malloc(200 * sizeof(symbol));

  if (argc < 2) {
    exit(1);
  }

  // Open the file
  file_pointer = fopen(argv[1], "r");
  if (file_pointer == NULL) {
    printf("Error opening file '%s'\n", argv[1]);
    exit(1);
  }

  // Assign the analizer file
  yyin = file_pointer;

  // Start analizing
  yylex();

  // Print symbol table
  print_symboltable();
}

void print_symboltable() {
  printf("–––– SYMBOL TABLE ––––\n");
  int symbol_table_size = sizeof symbol_table / sizeof *symbol_table ;
  for (int i = 0; i < 200; i++) {
    if (symbol_table[i].type) {
      printf("| T: %s \t V: '%s'\t|\n", token_names[*symbol_table[i].type], symbol_table[i].value);
    } else {
      printf(NULL);
    }
  }
}

void save(int type, char * value) {
  // Declare copies
  char *value_copy;
  int *type_copy;

  type_copy = malloc(sizeof(int));
  value_copy = malloc(sizeof(char)*strlen(value));

  *type_copy = type;
  // Copy the values of yytext pointer to a allocated copy
  strcpy(value_copy, value);

  // Assign value and type to symbol_table
  symbol_table[sIndex].value = value_copy;
  symbol_table[sIndex].type = type_copy;

  // Increment index
  sIndex++;
}

/* Bison does NOT implement yyerror, so define it here */
void yyerror (char *string){
  printf ("%s",string);
}
