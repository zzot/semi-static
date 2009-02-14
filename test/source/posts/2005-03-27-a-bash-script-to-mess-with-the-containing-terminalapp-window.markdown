---
title: A bash script to mess with the containing Terminal.app window
old-url: /2005/03/27/a_bash_script_t/
time: 22:51:28
utc-date: 2005-03-28 03:51:28
layout: post
author: Josh Dady
category: AppleScript
---

I found it, but I still don't have a clue as to why I wrote it to begin with:

    function setgeometry
    {
        local rows=`expr "$1" : '[0-9]*x([0-9]*)$'`
        local cols=`expr "$1" : '([0-9]*)x[0-9]*$'`
        case $TERM in
            Apple_Terminal)
                window=`osascript -e 'tell app "Terminal" to get first window'`
                #echo $window
                osascript -e 'tell app "Terminal"'
                                 -e "set number of rows of $window to $rows"
                                 -e "set number of columns of $window to $cols"
                             -e 'end tell'
                return $?
                ;;
            *)
                echo "Sorry, I don't know how to do that in $TERM"
                return 1
                ;;
        esac
    }
{: lang=bash }

It doesn't seem to work anymore, but the concept is still valid (i.e.,
`osascript -e 'tell app "Terminal"' -e 'set blib to first window' -e "get
blib's number of columns" -e 'end tell'` will actually tell you something,
although that's hardly a useful example).
