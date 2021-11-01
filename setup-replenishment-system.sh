#!/bin/bash

. ./scripts/utils.sh

#FIRST_CHANNEL=$2
#SECOND_CHANNEL=$3
#PROFILE=$4
DEPLOY_CHAINCODE=$1
FIRST_CHANNEL="channel1"
SECOND_CHANNEL="channel2"
PROFILE="TwoOrgsApplicationGenesis"

infoln "Creating a new smart home replenishment network..."

infoln "\n\n1. Erasing all previous generated content..."
./network.sh down

infoln "\n\n2. Creating the test network, containing org1 and org2..."
./network.sh up

infoln "\n\n3. Creating two new channels..."
./channel-controller.sh createChannel temp temp $FIRST_CHANNEL $PROFILE
./channel-controller.sh createChannel temp temp $SECOND_CHANNEL $PROFILE

infoln "\n\n4. Assigning org1 and org2 to the first channel ($FIRST_CHANNEL)..."
./channel-controller.sh addPeer 1 localhost:7051 $FIRST_CHANNEL temp
./channel-controller.sh addPeer 2 localhost:9051 $FIRST_CHANNEL temp

infoln "\n\n5. Assigning org1 to the second channel ($SECOND_CHANNEL)..."
./channel-controller.sh addPeer 1 localhost:7051 $SECOND_CHANNEL temp

infoln "\n\n6. Adding org3 to the network and the second channel ($SECOND_CHANNEL)..."
cd ./addOrg3
./addOrg3.sh up -c $SECOND_CHANNEL
cd ../

if [[ "$DEPLOY_CHAINCODE" == "deployCC" ]]; then
    infoln "\n\n7. Deploying chaincode to the channels..."
    ./deploy-smart-home-repl-chaincode.sh
else
    infoln "\n\n7. Skipping chaincode deployment."
fi



