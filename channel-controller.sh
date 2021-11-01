#!/bin/bash

# Needs CHANNEL_NAME and PROFILE.
createEmptyChannelWithOrderer() {
    echo "Creating empty channel ${CHANNEL_NAME} with profile ${PROFILE} with orderer"

    export FABRIC_CFG_PATH=${PWD}/configtx

    ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
    ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

    configtxgen -profile ${PROFILE} -outputBlock ./channel-artifacts/${CHANNEL_NAME}.block -channelID ${CHANNEL_NAME}

    osnadmin channel join \
        --channelID ${CHANNEL_NAME} \
        --config-block ./channel-artifacts/${CHANNEL_NAME}.block \
        -o localhost:7053 \
        --ca-file "$ORDERER_CA"\
        --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT"\
        --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
}

# Needs ORG_ADRESS, ORG_NUMBER and CHANNEL_NAME
addPeerToChannel() {
    echo "Adding peer for org with adress ${ORG_ADRESS} and number ${ORG_NUMBER} to channel ${CHANNEL_NAME}."

    export FABRIC_CFG_PATH=$PWD/../config/
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="Org${ORG_NUMBER}MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org${ORG_NUMBER}.example.com/peers/peer0.org${ORG_NUMBER}.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org${ORG_NUMBER}.example.com/users/Admin@org${ORG_NUMBER}.example.com/msp
    export CORE_PEER_ADDRESS=${ORG_ADRESS}

    peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block
}

# Sets the current selected peer. This can be used to check the channels, that the peer is currently in (peer channel list).
# Needs ORG_NUBMER and ORG_ADRESS
getPeerChannel() {
    export FABRIC_CFG_PATH=$PWD/../config/

    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="Org${ORG_NUMBER}MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org${ORG_NUMBER}.example.com/peers/peer0.org${ORG_NUMBER}.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org${ORG_NUMBER}.example.com/users/Admin@org${ORG_NUMBER}.example.com/msp
    export CORE_PEER_ADDRESS=${ORG_ADRESS}

    peer channel list
}

# Example input:
# ORG_NUBMER=1
# ORG_ADRESS=localhost:7051
# PROFILE='OneOrgsApplicationGenesis'

FUNCTION_NAME=$1
ORG_NUMBER=$2
ORG_ADRESS=$3
CHANNEL_NAME=$4
PROFILE=$5

if [[ "$FUNCTION_NAME" == "addPeer" ]]; then
    addPeerToChannel
fi

if [[ "$FUNCTION_NAME" == "createChannel" ]]; then
    createEmptyChannelWithOrderer
fi

if [[ "$FUNCTION_NAME" == "createChannelAndAddPeer" ]]; then
    createEmptyChannelWithOrderer
    addPeerToChannel
fi

if [[ "$FUNCTION_NAME" == "getPeerChannel" ]]; then
    getPeerChannel
fi