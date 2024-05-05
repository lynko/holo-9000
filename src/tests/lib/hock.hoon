/+  hock, *test

|%
  ++  test-grow-6
    ;:  weld
      %+  expect-eq
      !>  `*`10
      !>  (hock:hock 0 (grow:hock [6 [1 0] [1 10] 1 20]))
    ::
      %+  expect-eq
      !>  `*`20
      !>  (hock:hock 0 (grow:hock [6 [1 1] [1 10] 1 20]))
    ::
      %+  expect-eq
      !>  0
      !>  =>  (grow:hock [6 [1 2] [1 10] 1 20])  0
    ::
      %-  expect-fail
      |.  (hock:hock 0 (grow:hock [6 [1 2] [1 10] 1 20]))
    ==

  ++  test-grow-7
    %+  expect-eq
    !>  `*`43
    !>  (hock:hock 0 (grow:hock [7 [1 42] 4 0 1]))

  ++  test-grow-8
    %+  expect-eq
    !>  `*`[42 0]
    !>  (hock:hock 0 (grow:hock [8 [1 42] 0 1]))

  ++  test-grow-9
    %+  expect-eq
    !>  `*`42
    !>  (hock:hock 0 (grow:hock [9 2 1 [1 42] 0 1]))

  ++  test-grow-10
    ;:  weld
      %+  expect-eq
      !>  `*`0
      !>  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [1 1 0] 0 1]))
      ::
      %+  expect-eq
      !>  `*`[0 2 [3 4 5] 6 7]
      !>  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [2 1 0] 0 1]))
      ::
      %+  expect-eq
      !>  `*`[1 0 [3 4 5] 6 7]
      !>  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [6 1 0] 0 1]))
      ::
      %+  expect-eq
      !>  `*`[1 2 [0 4 5] 6 7]
      !>  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [28 1 0] 0 1]))
      ::
      %+  expect-eq
      !>  `*`[1 2 [3 0 5] 6 7]
      !>  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [58 1 0] 0 1]))
      ::
      %+  expect-eq
      !>  `*`[1 2 [3 4 0] 6 7]
      !>  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [59 1 0] 0 1]))
      ::
      %+  expect-eq
      !>  `*`[1 2 [3 4 5] 0 7]
      !>  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [30 1 0] 0 1]))
      ::
      %+  expect-eq
      !>  `*`[1 2 [3 4 5] 6 0]
      !>  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [31 1 0] 0 1]))
      ::
      %+  expect-eq
      !>  `*`[1 0]
      !>  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [3 1 0] 0 1]))
      ::
      %+  expect-eq
      !>  `*`[1 2 0]
      !>  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [7 1 0] 0 1]))
      ::
      %+  expect-eq
      !>  `*`[1 2 0 6 7]
      !>  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [14 1 0] 0 1]))
      ::
      %+  expect-eq
      !>  `*`[1 2 [3 4 5] 0]
      !>  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [15 1 0] 0 1]))
      ::
      %-  expect-fail
      |.  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [4 1 0] 0 1]))
      ::
      %-  expect-fail
      |.  (hock:hock [1 2 [3 4 5] 6 7] (grow:hock [10 [12 1 0] 0 1]))
      ::
      %+  expect-eq
      !>  `*`[42 43]
      !>  (hock:hock [42 0 43] (grow:hock [10 [2 0 2] 0 3]))
    ==

  ++  test-grow-cat
    ;:  weld
      %+  expect-eq
      !>  `*`(cat 2 1 1)
      !>  .*(cat (grow:hock [9 2 10 [6 1 2 1 1] 0 1]))
      ::
      %+  expect-eq
      !>  `*`(cat 2 1 1)
      !>
      %+  hock:hock  (grow:hock cat)
      [2 [[0 2] [1 2 1 1] 0 7] 1 2 [0 1] 0 2]
      ::
      %+  expect-eq
      !>  `*`(cat 2 1 1)
      !>
      %+  hock:hock  (grow:hock cat)
      (grow:hock [9 2 10 [6 1 2 1 1] 0 1])
      ::
      %+  expect-eq
      !>  `*`(cat 2 1 1)
      !>  .*((grow:hock cat) [9 2 10 [6 1 2 1 1] 0 1])
      ::
      %+  expect-eq
      !>  `*`(cat 2 1 1)
      !>  .*((grow:hock cat) (grow:hock [9 2 10 [6 1 2 1 1] 0 1]))
      ::
      %+  expect-eq
      !>  `*`(cat 3 1 1)
      !>  .*((grow:hock cat) (grow:hock [9 2 10 [6 1 3 1 1] 0 1]))
    ==
--
