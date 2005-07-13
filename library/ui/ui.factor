! Copyright (C) 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.
IN: gadgets
USING: kernel namespaces sdl sequences ;

IN: shells

: ui ( -- )
    #! Start the Factor graphics subsystem with the given screen
    #! dimensions.
    ?init-world
    world get shape-dim 2unseq 0 SDL_RESIZABLE [
        0 x set 0 y set [
            "Factor " version append dup SDL_WM_SetCaption
            ttf-init
            start-world
            run-world
        ] with-screen
    ] with-scope ;
