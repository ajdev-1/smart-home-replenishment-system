#!/bin/bash

. ./scripts/utils.sh

export FABRIC_CFG_PATH=$PWD/../config/

#CC_NAME=$1
#PATH=$2

CC_NAME="smart_home_replenishment_chaincode"
CC_PATH="./smart-home-replenishment-chaincode/"
CC_SEQUENCE=1
CC_VERSION=1.0

infoln "1. Create the chaincode package."
peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_PATH} --lang node --label ${CC_NAME}_${CC_VERSION}



# ----------------------------- START: INSTALL PROCESS ----------------------------- #
infoln "\n\n2. Install chaincode package on all three peers."
CHANNEL1="channel1"
CHANNEL2="channel2"

infoln "\n2.1 Installing on organisation 1..."
ORG=1
ADRESS="localhost:7051"
source ./set-org.sh ${ORG} ${ADRESS}
peer lifecycle chaincode install ./smart_home_replenishment_chaincode.tar.gz

infoln "\n--> Installed chaincodes on peer 1:"
peer lifecycle chaincode queryinstalled

infoln "\n--> Copy the package ID, paste it into the next line and press enter to continue..."
read CC_PACKAGE_ID

infoln "\n--> Approving chaincode definition with ID ${CC_PACKAGE_ID} with org ${ORG}, channel 1..."
# Only need to approve for one peer since chaincode definitions are approved on a organisational level.
# The other peers will get synched by the gossip protocol.
peer lifecycle chaincode approveformyorg \
  -o localhost:7050 \
  --ordererTLSHostnameOverride orderer.example.com \
  --channelID ${CHANNEL1} \
  --name ${CC_NAME} \
  --version ${CC_VERSION} \
  --package-id ${CC_PACKAGE_ID} \
  --sequence ${CC_SEQUENCE} \
  --tls \
  --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  # ----------------------------- START: APPROVE ----------------------------- #
  infoln "\n--> Approving chaincode definition with ID ${CC_PACKAGE_ID} with org ${ORG}, channel 2..."
  peer lifecycle chaincode approveformyorg \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --channelID ${CHANNEL2} \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --package-id ${CC_PACKAGE_ID} \
    --sequence ${CC_SEQUENCE} \
    --tls \
    --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
  # ----------------------------- END: APPROVE ----------------------------- #

infoln "\n2.2 Installing on organisation 2..."
ORG=2
ADRESS="localhost:9051"
source ./set-org.sh ${ORG} ${ADRESS}
peer lifecycle chaincode install ./smart_home_replenishment_chaincode.tar.gz

infoln "\n--> Installed chaincodes on peer 2:"
peer lifecycle chaincode queryinstalled

infoln "\n--> Copy the package ID, paste it into the next line and press enter to continue..."
read CC_PACKAGE_ID

  # ----------------------------- START: APPROVE ----------------------------- #
  infoln "\n--> Approving chaincode definition with ID ${CC_PACKAGE_ID} with org ${ORG}, channel 1..."
  # Only need to approve for one peer since chaincode definitions are approved on a organisational level.
  # The other peers will get synched by the gossip protocol.
  peer lifecycle chaincode approveformyorg \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --channelID ${CHANNEL1} \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --package-id ${CC_PACKAGE_ID} \
    --sequence ${CC_SEQUENCE} \
    --tls \
    --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
  # ----------------------------- END: APPROVE ----------------------------- #

infoln "\n2.3 Installing on organisation 3..."
ORG=3
ADRESS="localhost:11051"
source ./set-org.sh ${ORG} ${ADRESS}
peer lifecycle chaincode install ./smart_home_replenishment_chaincode.tar.gz

infoln "\n--> Installed chaincodes on peer 3:"
peer lifecycle chaincode queryinstalled

infoln "\n--> Copy the package ID, paste it into the next line and press enter to continue..."
read CC_PACKAGE_ID

  # ----------------------------- START: APPROVE ----------------------------- #
  infoln "\n--> Approving chaincode definition with ID ${CC_PACKAGE_ID} with org ${ORG}, channel 2..."
  # Only need to approve for one peer since chaincode definitions are approved on a organisational level.
  # The other peers will get synched by the gossip protocol.
  peer lifecycle chaincode approveformyorg \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --channelID ${CHANNEL2} \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --package-id ${CC_PACKAGE_ID} \
    --sequence ${CC_SEQUENCE} \
    --tls \
    --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
  # ----------------------------- END: APPROVE ----------------------------- #

# ----------------------------- END: INSTALL PROCESS ----------------------------- #



# ----------------------------- START: COMMIT PROCESS ----------------------------- #
infoln "\n\n3. Committing chaincode to both channels after they have been approved..."
# Here only one organisation is required to commit the chaincode definition to the channel since
# it already has been approved by a sufficient amount of channel members. However, the commit has to be done by
# an organisation admin.

  # ----------------------------- START: CHECK COMMIT READINESS ----------------------------- #
  ORG=2
  ADRESS="localhost:9051"
  source ./set-org.sh ${ORG} ${ADRESS}
  infoln "\n--> Commmit readiness for channel ${CHANNEL1}, package ID ${CC_PACKAGE_ID}, as org ${ORG} with adress ${ADRESS}"
  peer lifecycle chaincode checkcommitreadiness --channelID ${CHANNEL1} \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --sequence ${CC_SEQUENCE} \
    --tls \
    --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --output json

  ORG=3
  ADRESS="localhost:11051"
  source ./set-org.sh ${ORG} ${ADRESS}
  infoln "\n--> Commmit readiness for channel ${CHANNEL2}, package ID ${CC_PACKAGE_ID}, as org ${ORG} with adress ${ADRESS}"
  peer lifecycle chaincode checkcommitreadiness --channelID ${CHANNEL2} \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --sequence ${CC_SEQUENCE} \
    --tls \
    --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --output json
  # ----------------------------- END: CHECK COMMIT READINESS ----------------------------- #


  # ----------------------------- START: COMMIT TO CHANNELS ----------------------------- #
  ORG=2
  ADRESS="localhost:9051"
  source ./set-org.sh ${ORG} ${ADRESS}
  infoln "\n--> Commiting for channel ${CHANNEL1}, package ID ${CC_PACKAGE_ID}, as org ${ORG} with adress ${ADRESS}"
  # In the smart home replenishment setup, org 1 and org 2 are in channel 1.
  # This installs the chaincode on both peers within the channel.
  peer lifecycle chaincode commit \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --channelID ${CHANNEL1} \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --sequence ${CC_SEQUENCE} \
    --tls \
    --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
    --peerAddresses localhost:7051 \
    --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" \
    --peerAddresses localhost:9051 \
    --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"

  #infoln "\n--> Checking successfull commitment to the channel ${CHANNEL1}..."
  #peer lifecycle chaincode querycommitted \
  #  --channelID ${CHANNEL1} \
  #  --name ${CC_NAME} \
  #  --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  ORG=3
  ADRESS="localhost:11051"
  source ./set-org.sh ${ORG} ${ADRESS}
  infoln "\n--> Commiting for channel ${CHANNEL2}, package ID ${CC_PACKAGE_ID}, as org ${ORG} with adress ${ADRESS}"
  # In the smart home replenishment setup, org 1 and org 3 are in channel 2.
  # This installs the chaincode on both peers within the channel.
  peer lifecycle chaincode commit \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --channelID ${CHANNEL2} \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --sequence ${CC_SEQUENCE} \
    --tls \
    --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
    --peerAddresses localhost:7051 \
    --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" \
    --peerAddresses localhost:11051 \
    --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt"

  #infoln "\n--> Checking successfull commitment to the channel ${CHANNEL2}..."
  #peer lifecycle chaincode querycommitted \
  #  --channelID ${CHANNEL2} \
  #  --name ${CC_NAME} \
  #  --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
  # ----------------------------- END: COMMIT TO CHANNELS ----------------------------- #

# ----------------------------- END: COMMIT PROCESS ----------------------------- #


# EXAMPLES ON HOW TO INVOKE THE SMART HOME REPLENISHMENT CHAINCODE:
# Placeholder for needed parameters: 
#   - channel1 (channel)
#   - smart_home_replenishment_chaincode (name)
#   - on org1 and org2 peers
#   - function parameters = '{"function":"InitLedger","Args":[]}'
# Be sure to call ./setorg <ORG_NUMBER> <ORG_ADRESS> before running the command below. This will determine, which peer will be used to execute that command.
#
# Add a product:
# peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C channel1 -n smart_home_replenishment_chaincode --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"addProduct","Args":["water", "2", "Just water", "2", "org2"]}'
#
# Get specific product that you created
# peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C channel1 -n smart_home_replenishment_chaincode --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"getProductByNameAndOrg","Args":["water", "org2"]}'
#
# List all products with org x
# peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C channel1 -n smart_home_replenishment_chaincode --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"listProducts","Args":["org2"]}'
#
# Order a product
# peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C channel1 -n smart_home_replenishment_chaincode --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"orderProduct","Args":["consumer1", "water", "org2"]}'

