#!/bin/sh

mypass="$1"

/usr/bin/expect <<EOF
spawn /usr/bin/vncpasswd
expect "Password:"
send "$mypass\r"
expect "Verify:"
send "$mypass\r"
expect "Would you like to enter a view-only password"
send "n\r"
expect eof
exit
EOF
