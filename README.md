# AML

Agent Manipulation Language (AML) is a simple programming languages that compiles to C. It support describing the behaviors of agents and the computation geometry.

## How to get it

AML is implemented in OCaml

## Build from source

1. opam install ocamlfind
2. clone with git
3. make
4. ./main.native [file]

## Syntax

### Assignment
```c
int i = 1;
double f = 1.0;
string s = "1";
bool b = true;
ang d = (1, 0);
vec v = (1, 1);
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
if (a > 2) {
  println("Yes");
} else {
  println("No");
}
```

### Recursion

```
int fibonacci(int num) {
  if (num == 0 || num == 1) {
    return 0;
  } else {
    return (fibonacci(num - 2) + fibonacci(num - 1));
  }
}
```