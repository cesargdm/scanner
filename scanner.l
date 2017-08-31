%{
  #include <string.h>
  #include <stdio.h>
  #include <stdlib.h>

  #define RED   "\x1B[31m"
  #define RESET "\x1B[0m"

  // Reserved word type
  enum token_type{
    RESERVED_WORD,
    PUNCTUATION_TOKEN,
    RELATIONAL_TOKEN,
    ANL_OPERATOR,
    ASSIGNMENT_OPERATION,
    NUMBER,
    IDENTIFIER,
    FLOAT
  };

  // Array to get string value of token types
  const char* token_names[] = {
    "Reserved Word      ",
    "Punctuation Token  ",
    "Relational Token   ",
    "AnL Operators      ",
    "Assignment Operator",
    "Real number        ",
    "Identifier         ",
    "Float              "
  };

  // Create symbol struct
  typedef struct symbol {
    int *type;
    char *value;
    int *line;
  } symbol;

  symbol *symbol_table;

  // Create symbol table
  /*symbol *symbol_table = malloc(200 * sizeof(symbol_table));*/

  // Variables to get characters, words and lines
  int chars = 0;
  int words = 0;
  int lines = 1;
  int sIndex = 0;

  // Declare errors, functions and stuff
  void yyerror(char *string);
  void save(int, char *);
  void print_symboltable();
  void get_linebreaks(char *);
  int yyval;

%}

%%
\n { get_linebreaks(yytext); }
[/]{2}.* { }
(\/\*[^*]*\*+(?:[^/*][^*]*\*+)*\/) { { get_linebreaks(yytext); } }
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
([+-]?[1-9]\d*|0) { save(NUMBER, yytext); }
([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)? { save(FLOAT, yytext); }
[A-Za-z_][A-Za-z0-9_]* { save(IDENTIFIER, yytext); }
[ \t\r] { } // Ignore spaces
. { chars++; printf(RED "Unrecognized token: '%s' on line %d\n", yytext, lines);  printf("" RESET); }
%%

/*printf("Unknown word: %s", yytext);*/

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

  // Free table
  for (int i = 0; i <200; i+= 1) {
    free(symbol_table[i].type);
    free(symbol_table[i].value);
    free(symbol_table[i].line);
  }
}

void get_linebreaks(char * string) {
  // Check for more than one linebreak
  for (size_t i = 0; i < strlen(string); i++)
     if (string[i] == '\n') lines++;
}

void print_symboltable() {
  printf("\n\n\n");
  printf("Number of lines: %d\n", lines);
  printf("–––––––––––––––––––––––––––– SYMBOL  TABLE ––––––––––––––––––––––––––––\n");
  int symbol_table_size = sizeof symbol_table / sizeof *symbol_table ;
  for (int i = 0; i < 200; i++) {
    if (symbol_table[i].type) {
      printf("| TYPE: %s \t VALUE: '%s'\t\tLINE: %d\t|\n", token_names[*symbol_table[i].type], symbol_table[i].value, *symbol_table[i].line);
    } else {
      printf(NULL);
    }
  }
  printf("––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––\n");
}

void save(int type, char * value) {
  // Declare copies
  char *value_copy;
  int *type_copy;
  int *line_copy;

  // Allocate variables
  type_copy = malloc(sizeof(int));
  line_copy = malloc(sizeof(int));
  value_copy = malloc(sizeof(char)*strlen(value));

  *type_copy = type;
  *line_copy = lines;
  // Copy the values of yytext pointer to a allocated copy
  strcpy(value_copy, value);

  // Assign value and type to symbol_table
  symbol_table[sIndex].value = value_copy;
  symbol_table[sIndex].type = type_copy;
  symbol_table[sIndex].line = line_copy;

  // Increment index
  sIndex++;
}

/* Bison does NOT implement yyerror, so define it here */
void yyerror (char *string){
  printf ("%s",string);
}
