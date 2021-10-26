#!/bin/bash

. ./scripts/utils.sh

FIRST_CHANNEL=$1
SECOND_CHANNEL=$2
#PROFILE=$3
PROFILE="ZeroOrgsApplicationGenesis"

infoln "Creating a new smart home replenishment network..."
eccho "\n\n"

infoln "Erasing all previous generated content..."
./network.sh down

infoln "Creating the test network, containing org1 and org2..."
./network.sh up

infoln "Creating two new channels..."
./channel-controller.sh createChannel temp temp $FIRST_CHANNEL $PROFILE
./channel-controller.sh createChannel temp temp $SECOND_CHANNEL $PROFILE

infoln "Assigning org1 and org2 to the first channel ($FIRST_CHANNEL)..."
./channel-controller.sh addPeer 1 localhost:7051 $FIRST_CHANNEL temp
./channel-controller.sh addPeer 2 localhost:9051 $FIRST_CHANNEL temp

infoln "Assigning org1 to the second channel ($SECOND_CHANNEL)..."
./channel-controller.sh addPeer 1 localhost:7051 $SECOND_CHANNEL temp

infoln "Adding org3 to the network and the second channel ($SECOND_CHANNEL)..."
cd ./addOrg3
./addOrg3.sh up -c $SECOND_CHANNEL
cd ../





