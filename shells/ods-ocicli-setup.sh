#!/bin/bash

echo "This script provides OCI Datascience's OCI CLI authentication setup."
echo "This Script is supported by http://taewan.kim. (taewan.me@gmail.com)"
echo ""

echo "# Step1: Check Environment."
    echo " * This script should be executed on OCI Datascience Service"
if [[ $DATASCIENCE_USER = "datascience" ]]; then 
    echo " * This script is running on OCI Datascience Service"
    echo " "
else
    echo " * The current envorinment is not OCI Data Science "
    echo ""
    exit
fi

echo "# Step2: Check OCI User type: OCI User & Federation User"
if [[ $USER_OCID =~ "ocid1.saml2idp.oc1" ]]; then 
    echo " * This Notebook is provisioned by Federation User"
    echo " * Please Execute the following two commands After updating USER_OCID."
    echo " "
    echo " =========================================="
    echo " export USER_OCID=<REPACE Your User OCID>"
    echo " bash -c '$(curl -L http://taewan.kim/shells/ods-ocicli-setup.sh)'"
    echo " =========================================="    
    exit
else
    echo " * This Notebook is provisioned by OCI User"
    echo ""
fi

echo "# Step3: Delete old config files"
export BLOCK_STORAGE_PATH=/home/datascience
rm -rf ${BLOCK_STORAGE_PATH}/.oci 
rm -rf /home/datascience/.oci

echo ""
echo "# Step4: Generate ${BLOCK_STORAGE_PATH}/.oci/config file"

oci setup keys --output-dir ${BLOCK_STORAGE_PATH}/.oci --overwrite --passphrase 'a' > tmp_file
export FINGERPRINT=$(grep "Public key fingerprint: " tmp_file | cut -c 25-)

echo [DEFAULT] > ${BLOCK_STORAGE_PATH}/.oci/config
echo user=$USER_OCID >> ${BLOCK_STORAGE_PATH}/.oci/config
echo fingerprint=$FINGERPRINT >> ${BLOCK_STORAGE_PATH}/.oci/config
echo tenancy=$TENANCY_OCID >> ${BLOCK_STORAGE_PATH}/.oci/config 
echo region=$NB_REGION >> ${BLOCK_STORAGE_PATH}/.oci/config
echo key_file=~/.oci/oci_api_key.pem >> ${BLOCK_STORAGE_PATH}/.oci/config
echo pass_phrase=a >> ${BLOCK_STORAGE_PATH}/.oci/config
ln -s ${BLOCK_STORAGE_PATH}/.oci /home/datascience/.oci
oci setup repair-file-permissions --file /home/datascience/.oci/config 
rm ./tmp_file

echo " "
echo "*** The oci cli configuration is complete. ***"
echo "*** Please copy the api key below and paste into the Oracle Cloud Infrastructure Console ***"
echo " "
cat /home/datascience/.oci/oci_api_key_public.pem