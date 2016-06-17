! Copyright (C) 2004, 2010 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors arrays byte-arrays byte-vectors
classes.algebra.private classes.builtin classes.error
classes.intersection classes.maybe classes.mixin classes.parser
classes.predicate classes.singleton classes.tuple
classes.tuple.parser classes.union combinators compiler.units
definitions delegate effects effects.parser fry generic
generic.hook generic.math generic.parser generic.standard
hash-sets hashtables hashtables.identity io.pathnames kernel
lexer locals.errors locals.parser macros math memoize namespaces
parser quotations sbufs sequences slots source-files splitting
stack-checker strings strings.parser strings.parser.private
typed vectors vocabs vocabs.parser words words.alias
words.constant words.symbol delegate.private hints multiline ;
in: bootstrap.syntax

! These words are defined as a top-level form, instead of with
! defining parsing words, because during stage1 bootstrap, the
! "syntax" vocabulary is copied from the host. When stage1
! bootstrap completes, the host's syntax vocabulary is deleted
! from the target, then this top-level form creates the
! target's "syntax" vocabulary as one of the first things done
! in stage2.

: define-delimiter ( name -- )
    "syntax" lookup-word t "delimiter" set-word-prop ;

! Keep track of words defined by SYNTAX: as opposed to words
! merely generated by define-syntax.
: mark-top-level-syntax ( word -- word )
    dup t "syntax" set-word-prop ;

: define-core-syntax ( name quot -- )
    [
        dup "syntax" lookup-word [ ] [ no-word-error ] ?if
        mark-top-level-syntax
    ] dip
    define-syntax ;

! PREDICATE: fry-specifier < word { _ @ } member-eq? ;

: define-dummy-fry ( name -- word )
    "syntax" lookup-word
    [ "Only valid inside a fry" throw ] ( -- * )
    [ define-declared ] 3keep 2drop ;

: define-fry-specifier ( word words -- )
    [ \ word ] dip [ member-eq? ] curry define-predicate-class ;

: define-fry-specifiers ( names -- )
    [ define-dummy-fry ] map
    dup [ define-fry-specifier ] curry each ; 

[
    { "]" "}" ";" ">>" "COMPILE>" } [ define-delimiter ] each

    { "_" "@" } define-fry-specifiers
    ! "@" [ "Only valid inside a fry" throw ] ( -- * ) define-fry-specifier

     "![[" [
        "]]" parse-multiline-string drop
    ] define-core-syntax

     "![=[" [
        "]=]" parse-multiline-string drop
    ] define-core-syntax

     "![==[" [
        "]==]" parse-multiline-string drop
    ] define-core-syntax

    "PRIMITIVE:" [
        current-vocab name>>
        scan-word scan-effect ";" expect ensure-primitive
    ] define-core-syntax

    "CS{" [
        "Call stack literals are not supported" throw
    ] define-core-syntax

    "IN:" [ scan-token set-current-vocab ] define-core-syntax
    "in:" [ scan-token set-current-vocab ] define-core-syntax

    "PRIVATE<" [ begin-private ] define-core-syntax

    "PRIVATE>" [ end-private ] define-core-syntax

    "USE:" [ scan-token use-vocab ] define-core-syntax
    "use:" [ scan-token use-vocab ] define-core-syntax

    "UNUSE:" [ scan-token unuse-vocab ] define-core-syntax
    "unuse:" [ scan-token unuse-vocab ] define-core-syntax

    "USING:" [ ";" [ use-vocab ] each-token ] define-core-syntax

    "QUALIFIED:" [ scan-token dup add-qualified ] define-core-syntax
    "qualified:" [ scan-token dup add-qualified ] define-core-syntax

    "QUALIFIED-WITH:" [ scan-token scan-token ";" expect add-qualified ] define-core-syntax

    "FROM:" [
        scan-token "=>" expect ";" parse-tokens add-words-from
    ] define-core-syntax

    "EXCLUDE:" [
        scan-token "=>" expect ";" parse-tokens add-words-excluding
    ] define-core-syntax

    "RENAME:" [
        scan-token scan-token "=>" expect scan-token ";" expect add-renamed-word
    ] define-core-syntax

    "nan:" [ 16 scan-base <fp-nan> suffix! ] define-core-syntax

    "f" [ f suffix! ] define-core-syntax

    "char:" [
        lexer get parse-raw [ "token" throw-unexpected-eof ] unless* {
            { [ dup length 1 = ] [ first ] }
            { [ "\\" ?head ] [ next-escape >string "" assert= ] }
            [ name>char-hook get call( name -- char ) ]
        } cond suffix!
    ] define-core-syntax

    "\"" [ parse-string suffix! ] define-core-syntax

    "SBUF\"" [
        lexer get skip-blank parse-string >sbuf suffix!
    ] define-core-syntax

    "P\"" [
        lexer get skip-blank parse-string <pathname> suffix!
    ] define-core-syntax

    "[" [ parse-quotation suffix! ] define-core-syntax
    "{" [ \ } [ >array ] parse-literal ] define-core-syntax
    "V{" [ \ } [ >vector ] parse-literal ] define-core-syntax
    "B{" [ \ } [ >byte-array ] parse-literal ] define-core-syntax
    "BV{" [ \ } [ >byte-vector ] parse-literal ] define-core-syntax
    "H{" [ \ } [ parse-hashtable ] parse-literal ] define-core-syntax
    "T{" [ parse-tuple-literal suffix! ] define-core-syntax
    "W{" [ \ } [ first <wrapper> ] parse-literal ] define-core-syntax
    "HS{" [ \ } [ >hash-set ] parse-literal ] define-core-syntax

    "postpone\\" [ scan-word suffix! ] define-core-syntax
    "\\" [ scan-word <wrapper> suffix! ] define-core-syntax
    "M\\" [ scan-word scan-word lookup-method <wrapper> suffix! ] define-core-syntax
    "inline" [ last-word make-inline ] define-core-syntax
    "recursive" [ last-word make-recursive ] define-core-syntax
    "foldable" [ last-word make-foldable ] define-core-syntax
    "flushable" [ last-word make-flushable ] define-core-syntax
    "delimiter" [ last-word t "delimiter" set-word-prop ] define-core-syntax
    "deprecated" [ last-word make-deprecated ] define-core-syntax

    "@inline" [ last-word make-inline ] define-core-syntax
    "@recursive" [ last-word make-recursive ] define-core-syntax
    "@foldable" [ last-word make-foldable ] define-core-syntax
    "@flushable" [ last-word make-flushable ] define-core-syntax
    "@delimiter" [ last-word t "delimiter" set-word-prop ] define-core-syntax
    "@deprecated" [ last-word make-deprecated ] define-core-syntax

    "SYNTAX:" [
        scan-new-escaped
        mark-top-level-syntax
        parse-definition define-syntax
    ] define-core-syntax

    "BUILTIN:" [
        scan-word-name
        current-vocab lookup-word
        (parse-tuple-definition) 2drop check-builtin
    ] define-core-syntax

    "SYMBOL:" [
        scan-new-word define-symbol
    ] define-core-syntax
    "symbol:" [
        scan-new-word define-symbol
    ] define-core-syntax

    "SYMBOLS:" [
        ";" [ create-word-in [ reset-generic ] [ define-symbol ] bi ] each-token
    ] define-core-syntax

    "SINGLETONS:" [
        ";" [ create-class-in define-singleton-class ] each-token
    ] define-core-syntax

    "DEFER:" [
        scan-token current-vocab create-word
        [ fake-definition ] [ set-last-word ] [ undefined-def define ] tri
    ] define-core-syntax

    "defer:" [
        scan-token current-vocab create-word
        [ fake-definition ] [ set-last-word ] [ undefined-def define ] tri
    ] define-core-syntax


    "ALIAS:" [
        scan-new-escaped scan-escaped-word ";" expect define-alias
    ] define-core-syntax

    "CONSTANT:" [
        scan-new-word scan-object ";" expect define-constant
    ] define-core-syntax

    ":" [
        (:) define-declared
    ] define-core-syntax

    "GENERIC:" [
        [ simple-combination ] (GENERIC:)
    ] define-core-syntax

    "GENERIC#" [
        [ scan-number <standard-combination> ] (GENERIC:)
    ] define-core-syntax

    "MATH:" [
        [ math-combination ] (GENERIC:)
    ] define-core-syntax

    "HOOK:" [
        [ scan-word <hook-combination> ] (GENERIC:)
    ] define-core-syntax

    "M:" [
        (M:) define
    ] define-core-syntax

    "UNION:" [
        scan-new-class parse-definition define-union-class
    ] define-core-syntax

    "INTERSECTION:" [
        scan-new-class parse-definition define-intersection-class
    ] define-core-syntax

    "MIXIN:" [
        scan-new-class define-mixin-class
    ] define-core-syntax
    "mixin:" [
        scan-new-class define-mixin-class
    ] define-core-syntax

    "INSTANCE:" [
        location [
            scan-word scan-word ";" expect 2dup add-mixin-instance
            <mixin-instance>
        ] dip remember-definition
    ] define-core-syntax

    "PREDICATE:" [
        scan-new-class
        "<" expect
        scan-class
        parse-definition define-predicate-class
    ] define-core-syntax

    "SINGLETON:" [
        scan-new-class define-singleton-class
    ] define-core-syntax
    "singleton:" [
        scan-new-class define-singleton-class
    ] define-core-syntax

    "TUPLE:" [
        parse-tuple-definition define-tuple-class
    ] define-core-syntax

    "final" [
        last-word make-final
    ] define-core-syntax
    "@final" [
        last-word make-final
    ] define-core-syntax

    "SLOT:" [
        scan-token define-protocol-slot
    ] define-core-syntax
    "slot:" [
        scan-token define-protocol-slot
    ] define-core-syntax

    "C:" [
        scan-new-word scan-word ";" expect define-boa-word
    ] define-core-syntax

    "ERROR:" [
        parse-tuple-definition
        pick save-location
        define-error-class
    ] define-core-syntax

    "FORGET:" [
        scan-object forget
    ] define-core-syntax
    "forget:" [
        scan-object forget
    ] define-core-syntax

    "(" [
        ")" parse-effect suffix!
    ] define-core-syntax

    "MAIN:" [
        scan-word
        dup ( -- ) check-stack-effect
        [ current-vocab main<< ]
        [ current-source-file get [ main<< ] [ drop ] if* ] bi
    ] define-core-syntax
    "main:" [
        scan-word
        dup ( -- ) check-stack-effect
        [ current-vocab main<< ]
        [ current-source-file get [ main<< ] [ drop ] if* ] bi
    ] define-core-syntax

    "ARITY:" [
        scan-escaped-word scan-number "arity" set-word-prop
    ] define-core-syntax

    "LEFT-DECORATOR:" [
        scan-escaped-word t "left-decorator" set-word-prop
    ] define-core-syntax

    "<<" [
        [
            \ >> parse-until >quotation
        ] with-nested-compilation-unit call( -- )
    ] define-core-syntax

    "COMPILE<" [
        [
            \ COMPILE> parse-until >quotation
        ] with-nested-compilation-unit call( -- )
    ] define-core-syntax



    "call-next-method" [
        current-method get [
            literalize suffix!
            \ (call-next-method) suffix!
        ] [
            not-in-a-method-error
        ] if*
    ] define-core-syntax

    "maybe{" [
        \ } [ <anonymous-union> <maybe> ] parse-literal
    ] define-core-syntax

    "not{" [
        \ } [ <anonymous-union> <anonymous-complement> ] parse-literal
    ] define-core-syntax

    "intersection{" [
         \ } [ <anonymous-intersection> ] parse-literal
    ] define-core-syntax

    "union{" [
        \ } [ <anonymous-union> ] parse-literal
    ] define-core-syntax

    "initial:" "syntax" lookup-word define-symbol

    "read-only" "syntax" lookup-word define-symbol

    "call(" [ \ call-effect parse-call-paren ] define-core-syntax

    "execute(" [ \ execute-effect parse-call-paren ] define-core-syntax

    "::" [ (::) define-declared ] define-core-syntax
    "M::" [ (M::) define ] define-core-syntax
    "MACRO:" [ (:) define-macro ] define-core-syntax
    "MACRO::" [ (::) define-macro ] define-core-syntax
    "TYPED:" [ (:) define-typed ] define-core-syntax
    "TYPED::" [ (::) define-typed ] define-core-syntax
    "MEMO:" [ (:) define-memoized ] define-core-syntax
    "MEMO::" [ (::) define-memoized ] define-core-syntax
    "IDENTITY-MEMO:" [ (:) define-identity-memoized ] define-core-syntax
    "IDENTITY-MEMO::" [ (::) define-identity-memoized ] define-core-syntax

    ":>" [
        in-lambda? get [ :>-outside-lambda-error ] unless
        scan-token parse-def suffix!
    ] define-core-syntax

    "|[" [ parse-lambda append! ] define-core-syntax
    "let[" [ parse-let append! ] define-core-syntax
    "MEMO[" [ parse-quotation dup infer memoize-quot suffix! ] define-core-syntax
    "'[" [ parse-quotation fry append! ] define-core-syntax
    "IH{" [ \ } [ >identity-hashtable ] parse-literal ] define-core-syntax
    
    "PROTOCOL:" [
        scan-new-word parse-definition define-protocol
    ] define-core-syntax

    "CONSULT:" [
        scan-word scan-word parse-definition <consultation>
        [ save-location ] [ define-consult ] bi
    ] define-core-syntax

    "BROADCAST:" [
        scan-word scan-word parse-definition <broadcast>
        [ save-location ] [ define-consult ] bi
    ] define-core-syntax

    "SLOT-PROTOCOL:" [
        scan-new-word ";"
        [ [ reader-word ] [ writer-word ] bi 2array ]
        map-tokens concat define-protocol
    ] define-core-syntax

    "HINTS:" [
        scan-object dup wrapper? [ wrapped>> ] when
        [ changed-definition ]
        [ subwords [ changed-definition ] each ]
        [ parse-definition { } like set-specializer ] tri
    ] define-core-syntax
] with-compilation-unit
