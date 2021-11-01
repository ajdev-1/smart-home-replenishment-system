#!/bin/bash

ORG=$1
ADRESS=$2

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org${ORG}MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org${ORG}.example.com/peers/peer0.org${ORG}.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org${ORG}.example.com/users/Admin@org${ORG}.example.com/msp
export CORE_PEER_ADDRESS=${ADRESS}