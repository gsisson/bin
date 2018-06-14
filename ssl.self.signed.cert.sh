echo
echo "EXAMPLE generation of self signed certificate:"
echo "  openssl req -x509 -newkey rsa:4096 -keyout self.signed.key.pem -out self.signed.cert.pem -days 365 -sha256 -nodes -subj \"/C=US/ST=State/L=City/O=Company/OU=Org/CN=www.somewebsite.com\""
echo
