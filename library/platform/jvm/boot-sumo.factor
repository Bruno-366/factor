! :folding=indent:collapseFolds=1:

! $Id$
!
! Copyright (C) 2003, 2004 Slava Pestov.
! 
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:
! 
! 1. Redistributions of source code must retain the above copyright notice,
!    this list of conditions and the following disclaimer.
! 
! 2. Redistributions in binary form must reproduce the above copyright notice,
!    this list of conditions and the following disclaimer in the documentation
!    and/or other materials provided with the distribution.
! 
! THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
! INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
! FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
! DEVELOPERS AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
! SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
! PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
! OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
! WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
! OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
! ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

USE: parser

!!! The standard library.
"/library/platform/jvm/kernel.factor"       run-resource ! kernel
"/library/platform/jvm/vectors.factor"      run-resource ! vectors
"/library/platform/jvm/stack.factor"        run-resource ! stack
"/library/logic.factor"                     run-resource ! logic
"/library/platform/jvm/cons.factor"         run-resource ! lists
"/library/cons.factor"                      run-resource ! lists
"/library/combinators.factor"               run-resource ! combinators
"/library/platform/jvm/combinators.factor"  run-resource ! combinators
"/library/platform/jvm/math-types.factor"   run-resource ! arithmetic
"/library/platform/jvm/arithmetic.factor"   run-resource ! arithmetic
"/library/math/arithmetic.factor"           run-resource ! arithmetic
"/library/vectors.factor"                   run-resource ! vectors
"/library/platform/jvm/stack2.factor"       run-resource ! stack
"/library/math/math-combinators.factor"     run-resource ! arithmetic
"/library/vector-combinators.factor"        run-resource ! vectors
"/library/lists.factor"                     run-resource ! lists
"/library/assoc.factor"                     run-resource ! lists
"/library/hashtables.factor"                run-resource ! hashtables
"/library/platform/jvm/strings.factor"      run-resource ! strings
"/library/platform/jvm/sbuf.factor"         run-resource ! strings
"/library/strings.factor"                   run-resource ! strings
"/library/platform/jvm/errors.factor"       run-resource ! errors
"/library/platform/jvm/namespaces.factor"   run-resource ! namespaces
"/library/namespaces.factor"                run-resource ! namespaces
"/library/list-namespaces.factor"           run-resource ! namespaces
"/library/sbuf.factor"                      run-resource ! strings
"/library/math/namespace-math.factor"       run-resource ! arithmetic
"/library/continuations.factor"             run-resource ! continuations
"/library/errors.factor"                    run-resource ! errors
"/library/platform/jvm/vocabularies.factor" run-resource ! vocabularies
"/library/vocabularies.factor"              run-resource ! vocabularies
"/library/platform/jvm/words.factor"        run-resource ! words
"/library/words.factor"                     run-resource ! words
"/library/format.factor"                    run-resource ! format
"/library/platform/jvm/random.factor"       run-resource ! random
"/library/random.factor"                    run-resource ! random
"/library/platform/jvm/regexp.factor"       run-resource ! regexp
"/library/stream.factor"                    run-resource ! streams
"/library/platform/jvm/stream.factor"       run-resource ! streams
"/library/stdio.factor"                     run-resource ! stdio
"/library/platform/jvm/unparser.factor"     run-resource ! unparser
"/library/platform/jvm/parser.factor"       run-resource ! parser
"/library/styles.factor"                    run-resource ! styles
"/library/platform/jvm/threads.factor"      run-resource ! threads
"/library/logging.factor"                   run-resource ! logging

!!! Math library.
"/library/platform/jvm/real-math.factor" run-resource ! real-math
"/library/math/math.factor"              run-resource ! math
"/library/math/pow.factor"               run-resource ! math
"/library/math/trig-hyp.factor"          run-resource ! math
"/library/math/arc-trig-hyp.factor"      run-resource ! math
"/library/math/quadratic.factor"         run-resource ! math
"/library/math/list-math.factor"         run-resource ! math
"/library/math/simpson.factor"           run-resource ! math

!!! Development tools.
"/library/stdio-binary.factor"             run-resource ! stdio
"/library/vocabulary-style.factor"         run-resource ! style
"/library/prettyprint.factor"              run-resource ! prettyprint
"/library/platform/jvm/prettyprint.factor" run-resource ! prettyprint
"/library/interpreter.factor"              run-resource ! interpreter
"/library/inspector.factor"                run-resource ! inspector
"/library/inspect-vocabularies.factor"     run-resource ! inspector
"/library/platform/jvm/compiler.factor"    run-resource ! compiler
"/library/platform/jvm/debugger.factor"    run-resource ! debugger
"/library/debugger.factor"                 run-resource ! debugger
"/library/test/test.factor"                run-resource ! test
"/library/platform/jvm/test.factor"        run-resource ! test
"/library/ansi.factor"                     run-resource ! ansi
"/library/telnetd.factor"                  run-resource ! telnetd

!!! Java -> native VM image cross-compiler.
"/library/image.factor"                       run-resource ! cross-compiler
"/library/cross-compiler.factor"              run-resource ! cross-compiler
"/library/platform/jvm/cross-compiler.factor" run-resource ! cross-compiler

!!! HTTPD.
"/library/httpd/url-encoding.factor"       run-resource ! url-encoding
"/library/httpd/html.factor"               run-resource ! html
"/library/httpd/http-common.factor"        run-resource ! httpd
"/library/httpd/responder.factor"          run-resource ! httpd-responder
"/library/httpd/httpd.factor"              run-resource ! httpd
"/library/httpd/inspect-responder.factor"  run-resource ! inspect-responder
"/library/httpd/file-responder.factor"     run-resource ! file-responder
"/library/httpd/quit-responder.factor"     run-resource ! quit-responder
"/library/httpd/test-responder.factor"     run-resource ! test-responder
"/library/httpd/wiki-responder.factor"     run-resource ! wiki-responder
"/library/httpd/default-responders.factor" run-resource ! default-responders

!!! jEdit integration.
"/library/jedit/jedit-local.factor" run-resource  ! jedit
"/library/jedit/jedit-remote.factor" run-resource ! jedit
"/library/jedit/jedit.factor" run-resource        ! jedit

!!! Final initialization...
"/library/init.factor"                     run-resource ! init
"/library/platform/jvm/init.factor"        run-resource ! init
"/library/platform/jvm/listener.factor"    run-resource ! listener
