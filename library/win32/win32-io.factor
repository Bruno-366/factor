! :folding=indent:collapseFolds=1:

! $Id$
!
! Copyright (C) 2004 Slava Pestov.
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

IN: win32-api
USE: kernel
USE: alien

BEGIN-STRUCT: overlapped-ext
    FIELD: int internal
    FIELD: int internal-high
    FIELD: int offset
    FIELD: int offset-high
    FIELD: void* event
    FIELD: int user-data
END-STRUCT

: GENERIC_READ    HEX: 80000000 ;
: GENERIC_WRITE   HEX: 40000000 ;
: GENERIC_EXECUTE HEX: 20000000 ;
: GENERIC_ALL     HEX: 10000000 ;

: CREATE_NEW        1 ;
: CREATE_ALWAYS     2 ;
: OPEN_EXISTING     3 ;
: OPEN_ALWAYS       4 ;
: TRUNCATE_EXISTING 5 ;

: FILE_SHARE_READ 1 ;
: FILE_SHARE_WRITE 2 ;
: FILE_SHARE_DELETE 4 ;

: FILE_FLAG_WRITE_THROUGH       HEX: 80000000 ;
: FILE_FLAG_OVERLAPPED          HEX: 40000000 ;
: FILE_FLAG_NO_BUFFERING        HEX: 20000000 ;
: FILE_FLAG_RANDOM_ACCESS       HEX: 10000000 ;
: FILE_FLAG_SEQUENTIAL_SCAN     HEX: 08000000 ;
: FILE_FLAG_DELETE_ON_CLOSE     HEX: 04000000 ;
: FILE_FLAG_BACKUP_SEMANTICS    HEX: 02000000 ;
: FILE_FLAG_POSIX_SEMANTICS     HEX: 01000000 ;
: FILE_FLAG_OPEN_REPARSE_POINT  HEX: 00200000 ;
: FILE_FLAG_OPEN_NO_RECALL      HEX: 00100000 ;
: FILE_FLAG_FIRST_PIPE_INSTANCE HEX: 00080000 ;

: STD_INPUT_HANDLE  -10 ;
: STD_OUTPUT_HANDLE -11 ;
: STD_ERROR_HANDLE  -12 ;

: INVALID_HANDLE_VALUE -1 <alien> ;

: GetStdHandle ( id -- handle )
    "void*" "kernel32" "GetStdHandle" [ "int" ] alien-invoke ; 

: SetConsoleTextAttribute ( handle attrs -- ? )
    "bool" "kernel32" "SetConsoleTextAttribute" [ "void*" "int" ] 
    alien-invoke ;

: GetConsoleTitle ( buf size -- len )
    "int" "kernel32" "GetConsoleTitleA" [ "int" "int" ] alien-invoke ;

: SetConsoleTitle ( str -- ? )
    "bool" "kernel32" "SetConsoleTitleA" [ "char*" ] alien-invoke ;

: ReadFile ( handle buffer len out-len overlapped -- ? )
    "bool" "kernel32" "ReadFile" 
    [ "void*" "int" "int" "void*" "overlapped-ext*" ]
    alien-invoke ;

: WriteFile ( handle buffer len out-len overlapped -- ? )
    "bool" "kernel32" "WriteFile"
    [ "void*" "int" "int" "void*" "overlapped-ext*" ]
    alien-invoke ;

: CreateIoCompletionPort ( handle existing-port key numthreads -- )
    "void*" "kernel32" "CreateIoCompletionPort"
    [ "void*" "void*" "void*" "int" ]
    alien-invoke ;

: CreateFile ( name access sharemode security create flags template -- handle )
    "void*" "kernel32" "CreateFileA"
    [ "char*" "int" "int" "void*" "int" "int" "void*" ]
    alien-invoke ;

: CloseHandle ( handle -- ? )
    "bool" "kernel32" "CloseHandle" [ "void*" ] alien-invoke ;
   
