/+  boon, *test

|%
  ::  Test for parser failure.
  ::
  ++  reject
    |=  [t=(list tape)]  ^-  tang
    %+  reel  t
    |=  [i=tape t=tang]
    %-  weld  :_  t
    %-  expect-fail
    |.  ?>(=(+:(read:boon i) "") .)

  ::  Test for parser success. Does not indicate correct semantics.
  ::
  ++  accept
    |=  [t=(list tape)]
    %+  reel  t
    |=  [i=tape t=tang]
    %-  weld  :_  t
    %+  expect-eq
    !>  `*`""
    !>  +:(read:boon i)

  ::  Test for compiler failure.
  ::
  ++  forbid
    |=  [t=(list tape)]
    %+  reel  t
    |=  [i=tape t=tang]
    %-  weld  :_  t
    %-  expect-fail
    |.  (make:boon i)

  ::  Compile and run the given code, expecting a certain result.
  ::
  ++  expect
    |=  [a=* b=tape]
    %+  expect-eq
    !>  `*`a
    !>  `*`(eval:boon 0 b)
  --

|%
  ++  test-read-reject-empty-input
    %-  reject
    :~  ""   "\0a"   "\0a "
        " "  " \0a"  "  "
    ==

  ++  test-read-subject
    (accept ~[".."])

  ++  test-read-cab
    (accept ~["_"])

  ++  test-read-buc
    (accept ~["$"])

  ++  test-read-identifier
    ;:  weld
      (reject ~["-" "-a" "a-" "a0-" "-a-" "a--b" "a." "a.b" "a-b."])
      (accept ~["a" "abc" "a-b" "a0" "a0b" "a-0"])
    ==

  ++  test-read-0
    ;:  weld
      (reject ~["0." "0.0" "0.x"])
      (reject ~["00" "01" "0b0" "0x0"])
      (accept ~["0"])
    ==

  ++  test-read-tic
    ;:  weld
      (reject ~["` a" "`` a"])
      (accept ~["`a" "``a" "```a" "`$" "``$" "```$"])
    ==

  ++  test-read-dot
    ;:  weld
      (reject ~[". a b c" ".[a b c]"])
      (accept ~[".a b c" ".```a b c"])
    ==

  ++  test-read-col
    ;:  weld
      (reject ~[": a b c" ":[a b c] x x" ":`a b c" "::a b"])
      (accept ~[":a b c" ":: a b"])
    ==

  ++  test-read-kel
    ;:  weld
      (reject ~["[x" "[x y" "x]" "x y]"])
      (accept ~["[x]" "[[x]]" "[x y]" "[x y z]"])
      (accept ~["[[x] y z]" "[x [y] z]" "[x y [z]]" "[x [y z]]"])
    ==

  ++  test-read-wut
    ;:  weld
      (reject ~["?a b c"])
      (accept ~["? a b c"])
    ==

  ++  test-read-unary
    ;:  weld
      (reject ~["%$" "+1" "<a" ">a" "^a" "!a" "=a"])
      (accept ~["% $" "+ 1" "< a" "> a" "^ a" "! a" "= a"])
    ==

  ++  test-read-function
    ;:  weld
      (reject ~["\{" "\{}" "\{a}" "\{a}$"])
      (accept ~["\{} $" "\{a} $" "\{a b} $" "\{a b c} $" "\{ a } $"])
    ==

  ++  test-read-require-string-terminator
    (reject ~["'" "\"" "'\0a'" "'\0d'" "\"\0a\"" "\"\0d\""])

  ++  test-read-reject-control-codes
    ;:  weld
      (reject ~["\09.." "\0d.." "\7f.." "..\09" "..\0d" "..\7f"])
      (reject ~["\"\00\"" "\"\09\"" "\"\7f\"" "\"\80\""])
    ==

  ++  test-read-reject-unescaped-kel
    ;:  weld
      (reject ~["\"\{\""])
      (accept ~["\"\\\{\""])
    ==

  ++  test-read-allow-empty-string
    ;:  weld
      (expect 0 "''")
      (expect 0 "\"\"")
    ==

  ++  test-read-escape-codes
    ;:  weld
      (reject ~["'\\'" "'\\'''" "\"\\\"" "\"\\\"\"\""])
      (expect '\'' "'\\''")
      (expect '"' "'\\\"'")
      (expect "'" "\"\\'\"")
      (expect "\"" "\"\\\"\"")
      (expect '\ff\00' "'\\ff\\00'")
      (expect "\ff\00" "\"\\ff\\00\"")
    ==

  ++  test-read-reject-ellipses
    (reject ~["..." "...." "....." "...x" "... x" "... x x"])

  ++  test-forbid-unknown-identifier  (forbid ~["x" ".x 5 `x"])
  ++  test-forbid-push-tic  (forbid ~[":x 0 :`x 0 0"])
  ++  test-forbid-push-buc  (forbid ~[":$ 0 0"])
  ++  test-forbid-push-noun  (forbid ~[":[a b] [0 0] [a b]"])
  ++  test-forbid-push-subject  (forbid ~[":.. 0 0"])
  ++  test-forbid-set-buc  (forbid ~[".$ \{} .." ".`$ \{} .."])
  ++  test-forbid-set-noun  (forbid ~[".[a b] [0 0] a"])
  ++  test-forbid-set-subject  (forbid ~["... 0 0"])

  ++  test-crash
    (expect-fail |.((eval:boon 0 "_")))

  ++  test-cen
    ;:  weld
      (expect 0 "% 0")
      (expect 5 ":x 5 % x")
    ==

  ++  test-lus
    ;:  weld
      (expect 43 "+ 42")
      (expect 44 "+ + 42")
    ==

  ++  test-tis
    ;:  weld
      (expect 1 "= [0 1]")
      (expect 0 "= [0 0]")
      (expect 1 "= [[0 0] 0]")
      (expect 0 "= [[0 0] 0 0]")
    ==

  ++  test-buc
    (expect 7 ":a 5 :b 2 :c 0 % ? = [b c] a .a + a .c + c $")

  ++  test-gal
    (expect 10 "< [10 20]")

  ++  test-gar
    (expect 20 "> [10 20]")

  ++  test-ket
    ;:  weld
      (expect 0 "^ [1 1]")
      (expect 1 "^ 0")
    ==

  ++  test-zap
    ;:  weld
      (expect 0 "! 1")
      (expect 1 "! 0")
      (expect-fail |.((eval:boon 0 "! 2")))
      (expect-fail |.((eval:boon 0 "! [0 0]")))
    ==

  ++  test-wut
    ;:  weld
      (expect 5 "? 0 5 6")
      (expect 6 "? 1 5 6")
      (expect-fail |.((eval:boon 0 "? 2 5 6")))
    ==

  ++  test-tic
    ;:  weld
      (expect 5 ":x 5 :x 6 `x")
      (expect 5 ":x 6 :x 7 .`x 5 `x")
      (expect 5 ":x 5 :x 6 :x 7 ``x")
      (expect 5 ":a 1 % ? a 5 % .a 0 `$")
    ==

  ++  test-number
    ;:  weld
      (expect 0 "0")
      (expect 100 "100")
    ==

  ++  test-get-value  (expect 5 ":x 5 x")

  ++  test-change-value  (expect 6 ":x 5 .x 6 x")

  ++  test-add
    |^  ;:  weld
          (expect-eq !>(`*`333) !>((add 111 222)))
        ==
      ++  add
        |=  [a=@ud b=@ud]  ^-  *
        %+  eval:boon  0
        ;:  weld
          ":add \{a b} "
          "  :c 0 "
          "  % ? = [a c] b "
          "    .b + b .c + c $ "
          "(add [{(scow %ud a)} {(scow %ud b)}])"
        ==
    --
--
