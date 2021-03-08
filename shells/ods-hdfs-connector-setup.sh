#!/bin/bash

echo "This script provides a easy configuration for HDFS Connector in OCI Data Scinece Service."
echo "HDFS Connector lets Spark Application read and write data to and from Oracle Cloud Infrastructure Object Storage service"
echo "This Script is supported by http://taewan.kim. (taewan.me@gmail.com)"
echo ""

export BLOCK_STORAGE_PATH=/home/datascience
export CONFIG_FILE=${BLOCK_STORAGE_PATH}/spark_conf_dir/core-site.xml
export OCI_CONFIG_FILE=${BLOCK_STORAGE_PATH}/.oci/config

echo "* Step1: Chcek the configuration file for OCI CLI."
if [ ! -f $OCI_CONFIG_FILE ]; then
    echo "*** The configuration file for OCI-CLI does not exist."
    echo "*** The Configuration for OCI CLI should be completed before executing this script"
    echo "*** Please execute following commands in Notebook cell or Terminal for configuration of OCI CLI."
    echo ""
    echo "- In Notebook Cell"
    echo "%%bash" 
    echo "export USER_OCID=<REPACE with Your User OCID>"
    echo 'bash -c "$(curl -L http://taewan.kim/shells/ods-ocicli-setup.sh)'
    echo ""
    echo "- In Termial"
    echo "export USER_OCID=<REPACE with Your User OCID>"
    echo 'bash -c "$(curl -L http://taewan.kim/shells/ods-ocicli-setup.sh)'
    exit
else 
    echo "  - Pass"
fi

echo ""
echo "* Step2: Validate parametes of the configuration file for OCI CLI."

TENANCT_OCID=$(cat $OCI_CONFIG_FILE|grep tenancy)
prefix="tenancy="
empty=""
TENANCT_OCID=${TENANCT_OCID/$prefix/$empty}
prefix="tenancy = "
empty=""
export TENANCT_OCID=${TENANCT_OCID/$prefix/$empty}

#checking TENANCT_OCID. If Empty, Stop
if [ -z "$TENANCT_OCID" ]; then
    echo "TENANCT_OCID does not exists."
    echo "Please check the Configuration for OCI CLI."
    echo ""
    cat $OCI_CONFIG_FILE
    exit
else 
    echo "  - TENANCT_OCID: Pass"
fi

USER_OCID=$(cat $OCI_CONFIG_FILE|grep user)
prefix="user="
empty=""
USER_OCID=${USER_OCID/$prefix/$empty}
prefix="user = "
empty=""
export USER_OCID=${USER_OCID/$prefix/$empty}

#checking USER_OCID. If Empty, Stop
if [ -z "$USER_OCID" ]; then
    echo "USER_OCID does not exists."
    echo "Please check the Configuration for OCI CLI."
    echo ""
    cat $OCI_CONFIG_FILE
    exit
else 
    echo "  - USER_OCID: Pass"
fi

FINGER_PRINT=$(cat $OCI_CONFIG_FILE|grep fingerprint)
prefix="fingerprint="
empty=""
FINGER_PRINT=${FINGER_PRINT/$prefix/$empty}
prefix="fingerprint = "
empty=""
export FINGER_PRINT=${FINGER_PRINT/$prefix/$empty}

#checking FINGER_PRINT. If Empty, Stop
if [ -z "$FINGER_PRINT" ]; then
    echo "FINGER_PRINT does not exists."
    echo "Please check the Configuration for OCI CLI."
    echo ""
    cat $OCI_CONFIG_FILE
    exit
else 
    echo "  - FINGER_PRINT: Pass"
fi

KEY_FILE=$(cat $OCI_CONFIG_FILE|grep key_file)
prefix="key_file="
empty=""
KEY_FILE=${KEY_FILE/$prefix/$empty}
prefix="key_file = "
empty=""
export KEY_FILE=${KEY_FILE/$prefix/$empty}

#checking KEY_FILE. If Empty, Stop
if [ -z "$KEY_FILE" ]; then
    echo "KEY_FILE does not exists."
    echo "Please check the Configuration for OCI CLI."
    echo ""
    cat $OCI_CONFIG_FILE
    exit
else 
    echo "  - KEY_FILE: Pass"
fi


PASS_PHRASE=$(cat $OCI_CONFIG_FILE|grep pass_phrase)
prefix="pass_phrase="
empty=""
PASS_PHRASE=${PASS_PHRASE/$prefix/$empty}
prefix="pass_phrase = "
empty=""
export PASS_PHRASE=${PASS_PHRASE/$prefix/$empty}

echo ""
echo "* Step3: Generate The Configuration file for HDFS Connectors"
echo ""

echo '<configuration>' > $CONFIG_FILE
echo '  <property>' >> $CONFIG_FILE
echo '    <name>fs.oci.client.hostname</name>' >> $CONFIG_FILE
echo '    <value>'https://objectstorage.${NB_REGION}.oraclecloud.com'</value>' >> $CONFIG_FILE
echo '  </property>' >> $CONFIG_FILE
echo '  <property>' >> $CONFIG_FILE
echo '    <name>fs.oci.client.hostname.myBucket.myNamespace</name>' >> $CONFIG_FILE
echo '    <value>'https://objectstorage.${NB_REGION}.oraclecloud.com'</value>' >> $CONFIG_FILE
echo '  </property>' >> $CONFIG_FILE
echo '  <property>' >> $CONFIG_FILE
echo '    <name>fs.oci.client.auth.tenantId</name>' >> $CONFIG_FILE
echo '    <value>'${TENANCT_OCID}'</value>' >> $CONFIG_FILE
echo '  </property>' >> $CONFIG_FILE
echo '  <property>' >> $CONFIG_FILE
echo '    <name>fs.oci.client.auth.userId</name>' >> $CONFIG_FILE
echo '    <value>'${USER_OCID}'</value>' >> $CONFIG_FILE
echo '  </property>' >> $CONFIG_FILE
echo '  <property>' >> $CONFIG_FILE
echo '    <name>fs.oci.client.auth.fingerprint</name>' >> $CONFIG_FILE
echo '    <value>'${FINGER_PRINT}'</value>' >> $CONFIG_FILE
echo '  </property>' >> $CONFIG_FILE
echo '  <property>' >> $CONFIG_FILE
echo '    <name>fs.oci.client.auth.pemfilepath</name>' >> $CONFIG_FILE
echo '    <value>'${KEY_FILE}'</value>' >> $CONFIG_FILE
echo '  </property>' >> $CONFIG_FILE
if [ -n "$PASS_PHRASE" ]; then
echo '  <property>' >> $CONFIG_FILE
echo '    <name>fs.oci.client.auth.passphrase</name>' >> $CONFIG_FILE
echo '    <value>'$PASS_PHRASE'</value>' >> $CONFIG_FILE
echo '  </property>' >> $CONFIG_FILE
fi
echo '</configuration>' >> $CONFIG_FILE

echo "*** The configuration for HDFS Connector is completed. ***"
echo "*** PySpark code can access files in the OCI Object Storage ***"
echo "*** "$CONFIG_FILE
echo ""


cat $CONFIG_FILE