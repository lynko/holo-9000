# Holo project

An ambitious project to replace large portions of the Urbit stack.

| `lib/hock.hoon`       | Experimental replacement for Nock
| `lib/boon.hoon`       | Bootstrap compiler for the Loon language
| `tests/lib/hock.hoon` | Test suite for Hock
| `tests/lib/boon.hoon` | Test suite for Boon


## Hock

Hock is an extensible version of Nock. Valid Nock is always valid Hock.
Valid Hock is usually valid Nock.

```
^[x x]          0
^_              1
+[_ _]          _
+n              S(n)
=[x x]          0
=[_ _]          1
/[1 x]          x
/[2 x _]        x
/[3 _ x]        x
/[(n + n) x]    /[2 /[n x]]
/[S(n + n) x]   /[3 /[n x]]

*[x 0 n]        /[n x]
*[_ 1 x]        x
*[x 2 f]        **[x f]
*[x 3 f]        ^*[x f]
*[x 4 f]        +*[x f]
*[x 5 f]        =*[x f]

... extensions apply here ...

*[x f g]        [*[x f] *[x g]]
*x              _
```

`lib/hock.hoon` provides a Hock interpreter and a function for turning
Nock formulas into Hock formulas.


## Loon

Loon is a typeless version of Hoon. It shares many of Hoon's qualities,
but has far fewer operators. It is a thin layer over Nock. There's no
Loon compiler yet, but there is a compiler for Boon, a strict subset of
Loon, in `lib/boon.hoon`.

Like Hoon, Loon mostly consists of glyphs that receive a fixed number of
child expressions. Below is a table of operators available in Boon.

Operator | Meaning                 | Example
---------|-------------------------|-----------------------------
`^`      | Cell test (Nock 3)      | `^ x`
`+`      | Increment (Nock 4)      | `+ x`
`=`      | Equals (Nock 5)         | `= [x y]`
`!`      | Logical NOT             | `! x`
`<`      | Left of subject         | `< x`
`>`      | Right of subject        | `> x`
`.`      | Mutate subject          | `.x (f y) (add (g x) y)`
`..`     | Get subject             | `..`
`:`      | Pin value               | `:x (f y) (add (g x) y)`
`::`     | Cons                    | `:: [a b c] x`
`` ` ``  | Unshadow                | `` `x ``
`[` `]`  | Noun                    | `[a [b c] d]`
`{` `}`  | Function                | `{a b c} (add (mul a b) c)`
`(` `)`  | Function call           | `(add a b)`
`?`      | Branch                  | `? x a b`
`%`      | Set recursion point     | `% :x + x ..`
`$`      | Jump to recursion point | `% ? = [a x] b .x + x $`
`'`      | Cord                    | `'img'`
`"`      | Tape                    | `"hello"`
`_`      | Crash                   | `_`

In Boon, tokens must never be followed by a non-whitespace character,
unless that character is a closing bracket (`)]}`). This restriction
will be lifted in Loon.

Here is a portion of `hoon.hoon` translated to Boon:

```
:dec {a}
  ? = [0 a] _
  :b 0
  % ? = [a + b] b
    .b + b $

:lth {a b}
  ? = [a b] 1
  % ? = [0 a] 0
    ? = [0 b] 1
    .a (dec a) .b (dec b) $

:lte {a b}
  ? = [a b] 0
  (lth a b)

:gth {a b}
  ! (lte a b)

:gte {a b}
  ! (lth a b)

:min {a b}
  ? (lth a b) a b

:max {a b}
  ? (gth a b) a b

:add {a b}
  ? = [0 a] b
  .a (dec a) .b + b $

:sub {a b}
  ? = [0 b] a
  .a (dec a) .b (dec b) $

:mul {a b}
  :c 0
  % ? = [0 a] c
    .a (dec a) .c (add b c) $

:dvr {a b}
  ? = [0 b] _
  :c 0
  % ? (lth a b) [c a]
    .a (sub a b) .c + c $

:div {a b}
  < (dvr a b)

:mod {a b}
  > (dvr a b)

..
```

Note that the Boon compiler doesn't have access to jets and can be
extremely slow for large programs.
