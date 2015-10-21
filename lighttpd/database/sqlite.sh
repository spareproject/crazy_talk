#!/bin/env bash
#############################################################################################################################################################################################################
function delete_table { if [[ -f ./webserver.sqlite ]];then rm ./webserver.sqlite;fi; }
#############################################################################################################################################################################################################
function create_table {
sqlite3 ./webserver.sqlite <<< "
CREATE TABLE user(
  username        TEXT PRIMARY KEY UNIQUE,
  password        TEXT NOT NULL,
  email           TEXT NOT NULL UNIQUE,
  verified        TEXT,
  pubkey          TEXT NOT NULL,
  fingerprint     TEXT NOT NULL,
  salt            TEXT NOT NULL,
  last_successful INTEGER NOT NULL DEFAULT 0,
  last_failed     INTEGER NOT NULL DEFAULT 0,
  attempts        INTEGER NOT NULL DEFAULT 0,
  flag            INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE session(
  uuid              INTEGER PRIMARY KEY UNIQUE,
  username          TEXT NOT NULL,
  session           TEXT NOT NULL,
  session_expire    INTEGER NOT NULL,
  auth              TEXT,
  auth_expire       INTEGER DEFAULT 0,
  priv              TEXT,
  priv_expire       INTEGER DEFAULT 0,
  ip                TEXT,
  created           INTEGER,
  last_seen         INTEGER,
  challenge         TEXT,
  challenge_expire  INTEGER,
  response          TEXT,
  revoke            INTEGER DEFAULT 0,
  FOREIGN KEY(username) REFERENCES user(username) ON DELETE CASCADE ON UPDATE CASCADE
);
"
}
#############################################################################################################################################################################################################
function populate_table {
sqlite3 ./webserver.sqlite <<< "
INSERT INTO user(username,password,email,pubkey,fingerprint,salt) 
VALUES(
'booob',
'$(sha512sum<<<password)',
'bob@internetz.com',
'-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2

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
M/pQJN5S/g==
=Td1l
-----END PGP PUBLIC KEY BLOCK-----',
'55FA2CDC9DCED618330784A79843F987DC2759A4',
'$(dd if=/dev/random bs=1 count=128 2>/dev/null|tr -c 'a-zA-Z0-9' '.')'
);
"
}
#############################################################################################################################################################################################################
delete_table
create_table
populate_table
#############################################################################################################################################################################################################
