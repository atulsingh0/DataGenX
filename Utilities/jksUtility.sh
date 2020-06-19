#!/bin/sh


##################################################################
##                  Functions
##################################################################


genKeystore() {
	echo "Please provide below info as requested (hints are mentioned) - "
  read -p "CN Name : " -e CN
  read -p "Organizational Unit : " -e OU
  read -p "Organization : " -e O
  read -p "City Name : " -e L
  read -p "State or Province :" -e S
  read -p "Country Code : " -e C
  read -p "Keystore Password (min 6 char): " -e keyPass
  keytool -genkey -noprompt \
 -alias $CN \
 -dname "CN=$CN, OU=$OU, O=$O, L=$L, S=$S, C=$C" \
 -keystore ${CN}.jks \
 -storepass $keyPass \
 -keyPass $keyPass \
 -keyalg RSA \
 -sigalg SHA256withRSA \
 -validity 1095 \
 -keysize 4096 \
 && echo "" \
 && echo "KeyStore ${CN}.jks has been generated" \
 && echo "JKS Validity : 1095 days" \
 || echo "JKS generation has some issue, please look into the command"
 keytool -certreq -noprompt \
 -alias $CN \
 -keystore ${CN}.jks \
 -file ${CN}.csr \
 -storepass $keyPass \
 -keyPass $keyPass \
 && echo "" \
 && echo "CSR request ${CN}.csr has been generated" \
 && echo "You can submit thie CSR reuqest for CA approval" \
 || echo "CSR generation has some issue, please look into the command"
 echo "" && ls -l ${CN}*
	}


extPvtKey(){
	read -p "Enter the keystore Name: " -e keyStr
	read -p "Enter the keystore Password: " -e keyPass
  read -p "Enter key alian name: " -e keyAls
  keytool -importkeystore -srckeystore $keyStr \
  -srcstorepass $keyPass \
  -srckeypass $keyPass \
  -srcalias $keyAls \
  -srcstoretype JKS \
  -destalias $keyAls \
  -destkeystore $keyAls.p12 \
  -deststoretype PKCS12 \
  -deststorepass $keyPass \
  -destkeypass $keyPass \
  -noprompt \
  && openssl pkcs12 -in $keyAls.p12 -nodes -nocerts -out ${keyAls}.key -password pass:$keyPass \
  && rm $keyAls.p12 \
  && echo "" \
  && echo "Private Key are - ${keyAls}.key" \
  && ls -l ${keyAls}.key \
  || (rm $keyAls.p12 && echo "Either $keyAls does not exit in jks")
	}


extPubCert(){
	read -p "Enter the keystore Name: " -e keyStr
	read -p "Enter the keystore Password: " -e keyPass
  read -p "Enter key alian name: " -e keyAls
  keytool -export -alias $keyAls \
  -keystore $keyStr  \
  -file $keyAls.cer \
  -storepass $keyPass \
  -srcstoretype JKS \
  -rfc \
  -noprompt 
	}


impCerts(){
  echo "Put all the cer file in the same location where this script exist"
	read -p "Enter the keystore Name: " -e keyStr
 	read -p "Enter the keystore Password: " -e keyPass
  echo ""
  echo "#############################################################"
  for cert in `ls -1 *.cer`
  do
    echo "Importing cert $cert"
    keytool -importcert -keystore $keyStr -storepass $keyPass -alias ${cert%.*} -file $cert -noprompt
    echo "$cert imported into $keyStr"
  done
  echo "#############################################################"
	}


impCAcerts(){
  read -p "Enter the keystore Name: " -e keyStr
  read -p "Enter the keystore Password: " -e keyPass
  read -p "Enter the full name of root cert: " -e rootCert
  read -p "Enter the full name of intermediate cert: " -e intCert
  echo ""
  keytool -import -trustcacerts -alias ${rootCert%.*} -file ${rootCert} -keystore ${keyStr} -storepass $keyPass -noprompt \
  && keytool -import -trustcacerts -alias ${intCert%.*} -file ${intCert} -keystore ${keyStr} -storepass $keyPass -noprompt \
  && echo "CA certs are trusted in KeyStore" \
  || (echo "CA cert import error")
  echo ""
}


getValidity(){
	read -p "Enter the keystore Name: " -e keyStr
 	read -p "Enter the keystore Password: " -e keyPass
  echo ""
  echo "List of Certs in KeyStore with Validity"
  echo "#############################################################"
  keytool -list -keystore $keyStr -storepass $keyPass -v | egrep "Alias|Entry type|Serial|Valid" | sed "s/Alias/\\nAlias/g"
  echo ""
  echo "#############################################################"
	}


genKeystoreFrmCertNKey(){
  echo "Put *.cer & *.key file in the same location where this script exist"
	read -p "Enter the keystore Name: " -e keyStr
 	read -p "Enter the keystore Password: " -e keyPass
  echo ""
  mv "${keyStr%.*}.cer" "${keyStr%.*}.crt" \
  && openssl pkcs12 -export -in ${keyStr%.*}.crt -inkey ${keyStr%.*}.key -out ${keyStr%.*}.p12 -name ${keyStr%.*} -password pass:${keyPass} \
  && keytool -importkeystore -srckeystore ${keyStr%.*}.p12 \
  -destkeystore ${keyStr} -srcstorepass ${keyPass} \
  -deststorepass ${keyPass} -srcalias ${keyStr%.*} \
  -destalias ${keyStr%.*} -srcstoretype PKCS12 -noprompt \
  && rm ${keyStr%.*}.p12 \
  && echo "$keyStr generated" \
  && ls -l $keyStr \
  || (mv "${keyStr%.*}.crt" "${keyStr%.*}.cer"  && echo "JKS generation error")
}


###################################################################
##
##                             MAIN
##
###################################################################

echo ""
echo "#############################################################"
echo "####         Welcome to keystoreUtility.sh              #####"
echo "#############################################################"
echo ""
echo "Checking if java, openssl and keytool is available or not"
which java > /dev/null || (echo "java does not exist" && exit 1);
which openssl > /dev/null || (echo "openssl does not exist" && exit 1);
which keytool > /dev/null || (echo "keytoll does not exist" && exit 1);
echo ""
echo ""
echo "Choose one of the options (Enter no) - "
echo "1 - Generation of Keystore & CSR"
echo "2 - Extract Private Key from Keystore"
echo "3 - Extract Public Cert from Keystore"
echo "4 - Import Certs into Keystore"
echo "5 - Import CACerts into Keystore"
echo "6 - Check Validity of Certs in Keystore"
echo "7 - Generate KeyStore from Key and Cert file"
echo "99 - Exit"
echo ""
echo ""
while true; do 
  read -p "Option: " -e opt
    case $opt in
      "") echo "You did not choose any option, please try again"; break;;
      1) genKeystore; break;;
      2) extPvtKey; break;;
      3) extPubCert; break;;
      4) impCerts; break;;
      5) impCAcerts; break;;
      6) getValidity; break;;
      7) genKeystoreFrmCertNKey; break;;
      99) echo "Exiting from scripts"; exit 0;;
      *)  echo "Invalid Option, Please choose above listed options & hit Enter";;
    esac
done

