IN: temporary
USING: alien compiler errors inference io kernel memory
namespaces test threads ;

: callback-1 "void" { } [ ] alien-callback ; compiled

[ { 0 1 } ] [ [ callback-1 ] infer ] unit-test

[ t ] [ callback-1 alien? ] unit-test

FUNCTION: void callback_test_1 void* callback ; compiled

[ ] [ callback-1 callback_test_1 ] unit-test

: callback-2 "void" { } [ 5 throw ] alien-callback ; compiled

[ 5 ] [ [ callback-2 callback_test_1 ] catch ] unit-test

: callback-3 "void" { } [ 5 "x" set ] alien-callback ; compiled

[ t ] [ 
    namestack*
    3 "x" set callback-3 callback_test_1
    namestack* eq?
] unit-test

[ 5 ] [ 
    [
        3 "x" set callback-3 callback_test_1 "x" get
    ] with-scope
] unit-test

: callback-4 "void" { } [ "Hello world" write ] alien-callback ; compiled

[ "Hello world" ] [ 
    [ callback-4 callback_test_1 ] string-out
] unit-test

: callback-5
    "void" { } [ full-gc ] alien-callback ; compiled

[ "testing" ] [
    "testing" callback-5 callback_test_1
] unit-test

: callback-6
    "void" { } [ [ continue ] callcc0 ] alien-callback ; compiled

[ ] [ callback-6 callback_test_1 ] unit-test

: callback-7
    "void" { } [ yield "hi" print flush yield ] alien-callback ; compiled

[ ] [ callback-7 callback_test_1 ] unit-test
