# STEPS TO ENABLE 2-WAY TLS in PostgreSQL DB:

	- In the database/postgresql/conf/pg_hba.conf file, replace the value "trust" in the below line to "cert"
		
		1-way TLS : hostssl   all             all             all                     trust
		
		2-way TLS : hostssl   all             all             all                     trust
		

# COMMANDS TO ENABLE TLS in PostgreSQL DB:

	1-way TLS : start-postgresqldb-scripts.bat ssl (Windows)
				start-postgresqldb-scripts.sh ssl  (Linux)
	
	2-way TLS : start-postgresqldb-scripts.bat ssl mutual (Windows)
				start-postgresqldb-scripts.sh ssl mutual  (Linux)



# STEPS TO CREATE CERTIFICATES:
#--------------------------------------------------------------------------------Certificate Authority-------------------------------------------------------#
1. openssl genrsa -aes256 -out ca.key 4096
   #-- Removing the passphrase from CA certificate --#
2. openssl rsa -in ca.key -out ca.key   
3. openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt -subj "/C=IN/ST=TamilNadu/L=Chennai/O=Temenos/OU=Technology/CN=paymentorder Root CA/emailAddress=qwerty@yahoo.com"

#-------------------------------------------------------------------------------------Server-----------------------------------------------------------------#
1. openssl req -new -nodes -out server.csr -newkey rsa:4096 -keyout server.key -subj "/C=IN/ST=TamilNadu/L=Chennai/O=Temenos/OU=Technology/CN=server/emailAddress=qwerty@yahoo.com"
2. cat > server.v3.ext << EOF
   authorityKeyIdentifier=keyid,issuer
   basicConstraints=CA:FALSE
   keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
   subjectAltName = @alt_names
   [alt_names]
   DNS.1 = po-postgresqldb-service.postgresql.svc.cluster.local
   DNS.2 = localhost
   IP.1 = 127.0.0.1
EOF
3. openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 3650 -sha256 -extfile server.v3.ext

#-------------------------------------------------------------------------------------Client-----------------------------------------------------------------#
1. openssl req -new -nodes -out client.csr -newkey rsa:4096 -keyout client.key -subj "/C=IN/ST=TamilNadu/L=Chennai/O=Temenos/OU=Technology/CN=paymentorderusr/emailAddress=qwerty@yahoo.com"
2. openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 3650 -sha256
3. openssl pkcs8 -topk8 -outform DER -in client.key -out client.pk8 -nocrypt

#--------------------------------------------------------Points to remember while creating certificates & keys-----------------------------------------------#
1. Do not protect the private key with a passphrase. The server does not prompt for a passphrase for the private key, and the database startup fails with an error if one is required.
2. The CN of the client certificate should be same as database username
3. Note that the client private key file must be PKCS8 and stored in DER format, to be used:
        openssl pkcs8 -topk8 -outform DER -in client.key -out client.pk8 -nocrypt
4. The issuer of the cert must always be available and not be left empty. Certificate with empty issuer will produce error.
5. To view certificate contents: openssl x509 -noout -text -in <certificate_name>