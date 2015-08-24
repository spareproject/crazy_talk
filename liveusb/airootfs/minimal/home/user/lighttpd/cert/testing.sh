#!/bin/env bash
umask 377
# if index.txt isnt an empty file size 0 not a file with a new line in it kicks off and wont run
###############################################################################################################################################################################################################
#ROOT_KEY
openssl genrsa -out ./root/root.key 4096
openssl req -config ./root/root.cnf -key ./root/root.key -new -x509 -days 365 -sha256 -extensions root -out ./root/root.cert -subj '/CN=root'
###############################################################################################################################################################################################################
#PERSISTENT_KEY
openssl genrsa -out ./persistent/persistent.key 4096
openssl req -config ./persistent/persistent.cnf -new -sha256 -key ./persistent/persistent.key -out ./persistent/persistent.csr -subj '/CN=persistent'
openssl ca -config ./root/root.cnf -extensions persistent -days 365 -notext -md sha256 -in ./persistent/persistent.csr -out ./persistent/persistent.cert
###############################################################################################################################################################################################################
cat ./root/root.cert ./persistent/persistent.cert > ./ca-certificates.crt
###############################################################################################################################################################################################################
openssl genrsa -out ./localhost/localhost.key 4096
openssl req -config ./persistent/persistent.cnf -key ./localhost/localhost.key -new -sha256 -out ./localhost/localhost.csr -subj '/CN=localhost'
openssl ca -config ./persistent/persistent.cnf -extensions server -days 365 -notext -md sha256 -in ./localhost/localhost.csr -out ./localhost/localhost.cert
###############################################################################################################################################################################################################
openssl verify -CAfile ./ca-certificates.crt ./localhost/localhost.cert
###############################################################################################################################################################################################################
#openssl genrsa -out ./ocsp/root.ocsp.key 4096
#openssl req -config ./root/root.cnf -new -sha256 -key ./ocsp/root.ocsp.key -out ./ocsp/root.ocsp.csr -subj '/CN=root_ocsp'
#openssl ca -config ./root/root.cnf -extensions ocsp -days 365 -notext -md sha256 -in ./ocsp/root.ocsp.csr -out ./ocsp/root.ocsp.cert
###############################################################################################################################################################################################################
#openssl genrsa -out ./ocsp/persistent.ocsp.key 4096
#openssl req -config ./persistent/persistent.cnf -new -sha256 -key ./ocsp/persistent.ocsp.key -out ./ocsp/persistent.ocsp.csr -subj '/CN=persistent_ocsp'
#openssl ca -config ./persistent/persistent.cnf -extensions ocsp -days 365 -notext -md sha256 -in ./ocsp/persistent.ocsp.csr -out ./ocsp/persistent.ocsp.cert
###############################################################################################################################################################################################################
#revoke a key...
# mkdir ./test
#openssl genrsa -out ./test/test.key 4096 
#openssl req -config ./persistent/persistent.cnf -key ./test/test.key -new -sha256 -out ./test/test.csr -subj '/CN=test'
#openssl ca -config ./persistent/persistent.cnf -extensions server -days 375 -notext -md sha256 -in ./test/test.csr -out ./test/test.cert
###############################################################################################################################################################################################################
# starts ocsp, hosts ca-certificates.crt, using the persistent ocsp key/cert
#openssl ocsp -port 8081 -text -sha256 -index ./index.txt -ca ./ca-certificates.crt -rkey ./ocsp/persistent.ocsp.key -rsigner ./ocsp/persistent.ocsp.cert -nrequest 1 &
# query ocsp with cert, cert in query and the cert it was signed with
#revoke the test key
#openssl ca -config ./persistent.cnf -revoke ./test/test.cert
#rerun the responder on localhost...
#openssl ocsp -port 8081 -text -sha256 -index ./index.txt -ca ./ca-certificates.crt -rkey ./ocsp/persistent.ocsp.key -rsigner ./ocsp/persistent.ocsp.cert -nrequest 1 &
#send a query to it...
#openssl ocsp -CAfile ./ca-certificates.crt -url http://localhost:8081 -resp_text -issuer ./persistent/persitent.cert -cert ./test/test.cert
###############################################################################################################################################################################################################
#openssl x509 -noout -text -in test.pem 
###############################################################################################################################################################################################################
