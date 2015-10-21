#!/bin/env bash

sqlite3 /home/user/lighttpd/database/webserver.sqlite <<< "select challenge from session where uuid=1;"

sqlite3 /home/user/lighttpd/database/webserver.sqlite <<< "select challenge from session where uuid=1;"|
gpg --homedir /home/user/lighttpd/test_data/booob -d

