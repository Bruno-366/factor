! Copyright (C) 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.
IN: gadgets
USING: arrays generic hashtables kernel lists math
namespaces sequences styles ;

SYMBOL: origin

@{ 0 0 0 }@ origin global set-hash

TUPLE: rect loc dim ;

M: array rect-loc ;

M: array rect-dim drop @{ 0 0 0 }@ ;

: rect-bounds ( rect -- loc dim ) dup rect-loc swap rect-dim ;

: rect-extent ( rect -- loc ext ) rect-bounds over v+ ;

: 2rect-extent ( rect rect -- loc1 loc2 ext1 ext2 )
    [ rect-extent ] 2apply swapd ;

: |v-| ( vec vec -- vec ) v- [ 0 max ] map ;

: <extent-rect> ( loc ext ) dupd swap |v-| <rect> ;

: >absolute ( rect -- rect )
    rect-bounds >r origin get v+ r> <rect> ;

: (rect-intersect) ( rect rect -- array array )
    2rect-extent vmin >r vmax r> ;

: rect-intersect ( rect rect -- rect )
    (rect-intersect) <extent-rect> ;

: intersects? ( rect/point rect -- ? )
    (rect-intersect) v- [ 0 <= ] all? ;

: rect-union ( rect rect -- rect )
    2rect-extent vmax >r vmin r> <extent-rect> ;

TUPLE: gadget
    parent children orientation
    gestures visible? relayout? root?
    interior boundary ;

: show-gadget t swap set-gadget-visible? ;

: hide-gadget f swap set-gadget-visible? ;

M: gadget = eq? ;

: gadget-child gadget-children first ;

C: gadget ( -- gadget )
    @{ 0 0 0 }@ dup <rect> over set-delegate dup show-gadget
    @{ 0 1 0 }@ over set-gadget-orientation ;

: delegate>gadget ( tuple -- ) <gadget> swap set-delegate ;

GENERIC: user-input* ( ch gadget -- ? )

M: gadget user-input* 2drop t ;

: invalidate ( gadget -- ) t swap set-gadget-relayout? ;

DEFER: add-invalid

GENERIC: children-on ( rect/point gadget -- list )

M: gadget children-on ( rect/point gadget -- list )
    nip gadget-children ;

: inside? ( bounds gadget -- ? )
    dup gadget-visible?
    [ >absolute intersects? ] [ 2drop f ] if ;

: pick-up-list ( rect/point gadget -- gadget/f )
    dupd children-on reverse-slice [ inside? ] find-with nip ;

: translate ( rect/point -- new-origin )
    rect-loc origin [ v+ dup ] change ;

: pick-up ( rect/point gadget -- gadget )
    [
        2dup inside? [
            dup translate drop 2dup pick-up-list dup
            [ nip pick-up ] [ rot 2drop ] if
        ] [ 2drop f ] if
    ] with-scope ;

: max-dim ( dims -- dim ) @{ 0 0 0 }@ [ vmax ] reduce ;

: set-gadget-delegate ( delegate gadget -- )
    dup pick gadget-children [ set-gadget-parent ] each-with
    set-delegate ;

! Pointer help protocol
GENERIC: gadget-help

M: gadget gadget-help drop f ;
