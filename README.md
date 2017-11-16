# AML

Agent Manipulation Language (AML) is a simple programming languages that compiles to C. It support describing the behaviors of agents and the computation geometry.

## How to get it

AML is implemented in OCaml

## Build from source

1. Clone with git 
2. make
3. ./calc

## Syntax

### Assignment

```c
a = 1;
b = "string";
c = true
```

### Expression

```c
a = 1 + 2;
b = a * 7;
```

### Function

```c
func f(a, b){
   a = a + b;
   b = b - a;
}
```

### Loop
```c
for(i = 1; i < 2; i = i + 1)
{
   a = 3 + 2;
}
```
