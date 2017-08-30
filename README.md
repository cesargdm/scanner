# Lexical Analysis
> Lexical analyzer (scanner) for tiny C

---
## Description

The language recognizes the following tokens:

- Reserved words: “int” “float” “if” “then” “else” "while" “read” “write”
- Punctuation tokens: “,” “;” “(” “)” “{” “}”
- Relational tokens: “<” “=” "<=" ">=" "!="
- Arithmetic and Logic operations: “+” “-” “*” “/”
- Assignment operation: “:=”
- Numbers are expressed by the following regular expression:
[1-9][0-9]* | 0(c|C)[0-7]+ | 0(x|X)[0-9A-Fa-f]+ | [+-]?[0-9]*”.”[0-9]+([eE][-+]?[0-9]+)?
- Identifiers are expressed by the following regular expression: [A-Za-z_][A-Za-z0-9_]*
- Comments are similar to those in C "/* comment */"and can span multiple lines.

---
## Build

Build flex file
```
flex scanner.l
```


Compile output
```
gcc ./lex.yy.c -lfl -o scanner
```

Run with file
```
./scanner ./examples/example.tc
```

**All in one command**

```
flex scanner.l && gcc ./lex.yy.c -lfl -o scanner && ./scanner ./examples/example.tc
```

&copy; 2017 cesargdm
