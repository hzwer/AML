## Introduction

Agent Manipulation Language (AML) is a programming languages that compiles to C. It support describing the behaviors of agents and the computation geometry.

AML is implemented in OCaml.There are some slides made by myself.

[Introduction to Ocaml](https://drive.google.com/file/d/1EE53Btye7TAuW0bBTSjNVrvH-40I1ifR/view?usp=sharing)

[Introduction to AML](https://drive.google.com/file/d/1BtA4K1q3Tp2fpJ_MfmQF-BdTkDTEem14/view?usp=sharing)

## How to get it

###Build from source

1. install glut // for mac OS, Xcode bring the glut 
2. opam install menhir
3. clone with git
4. make
5. ./main.native [file] 

### Test

```
$ make test
```

## Test things with openGL:

```
$ cd demo

$ g++ -o main demo1.cpp -lglut -lGL # for ubuntu

$ g++ -framework OpenGL -framework GLUT -framework Foundation -o main demo1.cpp # for mac OS

$ ./main
```

## Syntax

### Assignment
```c
int i = 1;
double f = 1.0;
string s = "1";
bool b = true;
ang d = (1, 0);
vec2f v = (1, 1);
```

### Arithmetic
```c
println(false, true, 42);
println(1 + (4 + 6) * 3);
println(8 - 3 % 2);
println(-9 - 9);
println((2 + 8) / 3);
```

### Comment
```c
/* This is a multi-line comment */
// This is a single-line comment
```

### Loop
```c
int sum;
for(int i = 1; i <= 100; i = i + 1) {
    sum = sum + i;
}
```

### Condition
```c
int a = 3;
if (a > 2)
  println("Yes");
else {
  println("No");
}
```

### Recursion

```c
int fibonacci(int num) {
  if (num == 0)
    return(0);
  else if(num == 1)
    return(1);
  else return (fibonacci(num - 2) + fibonacci(num - 1));
}
```
## Contributors

* [hzwer](https://github.com/hzwer)

* [wmdcstdio](https://github.com/wmdcstdio)

## Reference

[Batsh](https://github.com/BYVoid/Batsh)

[ocamllex, ocamlyacc](http://caml.inria.fr/pub/docs/manual-ocaml/lexyacc.html)

[An Introduction to Objective Caml](http://www1.cs.columbia.edu/~sedwards/classes/2014/w4115-fall/ocaml.pdf)

[One-Day Compilers](http://venge.net/graydon/talks/mkc/html/index.html)
