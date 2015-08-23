#!/bin/env bash
umask 377
###############################################################################################################################################################################################################
# create the root key
read -p "generating root private key"
openssl genrsa -out ./root/root.key 4096
read -p "generating root cert"
openssl req -config ./root/root.cnf -key ./root/root.key -new -x509 -days 365 -sha256 -extensions v3_root -out ./root/root.cert -subj '/CN=root'
read -p "verify the certificate"
openssl x509 -noout -text -in ./root/root.cert
###############################################################################################################################################################################################################
# create the ca key
read -p "generating ca private key"
openssl genrsa -out ./ca/ca.key 4096
read -p "generating ca csr"
openssl req -config ./ca/ca.cnf -new -sha256 -key ./ca/ca.key -out ./ca/ca.csr -subj '/CN=ca'
read -p "generating ca cert"
openssl ca -config ./root/root.cnf -extensions v3_ca -days 365 -notext -md sha256 -in ./ca/ca.csr -out ./ca/ca.cert
read -p "verify the certificate"
openssl x509 -noout -text -in ./ca/ca.cert
read -p "creating certificate chain root-ca.chain"
###############################################################################################################################################################################################################
cat ./ca/ca.cert ./root/root.cert > certs/root-ca.chain
###############################################################################################################################################################################################################
read -p "generating localhost private key"
openssl genrsa -out ./localhost/localhost.key 4096
read -p "generating localhost csr"
openssl req -config ./ca/ca.cnf -key ./localhost/localhost.key -new -sha256 -out ./localhost/localhost.csr -subj '/CN=localhost'
read -p "generating ca cert"
openssl ca -config ./ca/ca.cnf -extensions server_cert -days 365 -notext -md sha256 -in ./localhost/localhost.csr -out ./localhost/localhost.cert
read -p "verify the certificate"
openssl x509 -noout -text -in ./localhost/localhost.cert
read -p "verify the certificate chain"
openssl verify -CAfile ./certs/root-ca.chain ./localhost/localhost.cert
###############################################################################################################################################################################################################

###############################################################################################################################################################################################################
read -p "generating root ocsp revocation key"
openssl genrsa -out ./ocsp/root.ocsp.key 4096
read -p "generating root ocsp revocation csr"
openssl req -config ./root/root.cnf -new -sha256 -key ./ocsp/root.ocsp.key -out ./ocsp/root.ocsp.csr -subj '/CN=rootocsp'
read -p "generating root ocsp revocation cert"
openssl ca -config ./root/root.cnf -extensions ocsp -days 365 -notext -md sha256 -in ./ocsp/root.ocsp.csr -out ./ocsp/root.ocsp.cert
###############################################################################################################################################################################################################
read -p "generating ca ocsp revocation key"
openssl genrsa -out ./ocsp/ca.ocsp.key 4096
read -p "generating ca ocsp revocation csr"
openssl req -config ./ca/ca.cnf -new -sha256 -key ./ocsp/ca.ocsp.key -out ./ocsp/ca.ocsp.csr -subj '/CN=caocsp'
read -p "generating ca ocsp revocation cert"
openssl ca -config ./ca/ca.cnf -extensions ocsp -days 365 -notext -md sha256 -in ./ocsp/ca.ocsp.csr -out ./ocsp/ca.ocsp.cert
###############################################################################################################################################################################################################
#revoke a key...
read -p "generating test private key"
openssl genrsa -out ./test/test.key 4096 
read -p "generating test csr"
openssl req -config ./ca/ca.cnf -key ./test/test.key -new -sha256 -out ./test/test.csr -subj '/CN=test'
read -p "generating test cert"
openssl ca -config ./ca/ca.cnf -extensions server_cert -days 375 -notext -md sha256 -in ./test/test.csr -out ./test/test.cert
###############################################################################################################################################################################################################
#run the responder on localhost...
openssl ocsp -port 8082 -text -sha256 -index ./index.txt -ca ./certs/root-ca.chain -rkey ./ocsp/ca.ocsp.key -rsigner ./ocsp/ca.ocsp.cert -nrequest 1 &
#send a query to it...
openssl ocsp -CAfile ./certs/root-ca.chain -url http://localhost:8082 -resp_text -issuer ./ca/ca.cert -cert ./test/test.cert

# should reply that its still up

#revoke the test key
openssl ca -config ./ca/ca.cnf -revoke ./test/test.cert

#run the responder on localhost...
openssl ocsp -port 8082 -text -sha256 -index ./index.txt -ca ./certs/root-ca.chain -rkey ./ocsp/ca.ocsp.key -rsigner ./ocsp/ca.ocsp.cert -nrequest 1 &
#send a query to it...
openssl ocsp -CAfile ./certs/root-ca.chain -url http://localhost:8082 -resp_text -issuer ./ca/ca.cert -cert ./test/test.cert

# should reply its been revoked

###############################################################################################################################################################################################################
#-config
#openssl req -x509 -nodes -newkey rsa:4096 -sha512 -days 0 -out ./root.pem       -keyout ./root.key -extensions v3_ca
#openssl req -x509 -nodes -newkey rsa:4096 -sha512 -days 0 -out ./ca.pem         -keyout ./ca.key -extensions v3_intermediate_ca
#openssl req -x509 -nodes -newkey rsa:4096 -sha512 -days 0 -out ./localhost.pem  -keyout ./localhost.key
#-subj '/CN=localhost'
# generate a csr - apperently can do this while generating key?
#openssl x509 -x509toreq -in ca.pem -out ca.csr -signkey ca.key 
# to work with arch default openssl.cnf
#mkdir /etc/ssl/newcerts
#touch /etc/ssl/index.txt
#echo -e "01\n" > /etc/ssl/serial
#cp root.key /etc/ssl/private/cakey.pem
#cp root.pem /etc/ssl/cacert.pem
# ^ only to sign the actual ca with the root key... then key swap again to sign the actual lighttpd key
#openssl ca -out ca.cert -infiles ca.csr
#openssl x509 -noout -text -in test.pem 
