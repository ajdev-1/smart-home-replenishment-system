## Project description

In the world of smart home replenishment, most of the solutions are lacking specific functionalities. [Dash buttons](https://en.wikipedia.org/wiki/Amazon_Dash) for example are not really measuring the exact needs of the customer. If you place the dash button near your toothpaste and click it as soon as the toothpaste runs emtpy, well, then you will need to wait for the package to arrive to refill your toothpaste. On the other hand smart solutions like the smart HP ink printer ([Instant Ink](https://www.hp.com/de-de/shop/offer.aspx?p=instantink)) and the smart washing machine from Hoover are measuring the exact needs of the customer through constant monitoring of the washing powder or ink. However, in this case a customer needs two systems for two products. This does not scale well at all with adding more smart products to the household.

To provide a single platform for many smart home appliances, Amazon launched the [Amazon Dash Replenishment Service](https://developer.amazon.com/en-US/alexa/dash-services). This service allows manufacturers to use the Amazon APIs to make their products smart by monitoring the actual needs of the customer. In that way reorders happen automatically when the appliance runs low. However, with this solution manufacturers are very dependant on Amazon. Amazon serves as a single source of truth for all manufacturers and their data. So in the end Amazon will have knowledge of all the reorders that happen within the system.

This project aims to provide a decentralized solution to manufacturers which means the middleman like Amazon will be omitted. This means that the manufacturers will have direct contact to the customers and their data. With that the system provides more data democracy to the manufacturers. Also, the dependency between manufacturers and a potential middleman can be omitted, saving costs in term of contractual fees.

## Technology
 * [Hyperledger Fabric](https://www.hyperledger.org/use/fabric)
 * [Smart Contracts with NodeJS](https://nodejs.org/en/)
 * [Built upon the official Hyperledger Fabric fabric-samples repository](https://github.com/hyperledger/fabric-samples)

## Decentralized infrastructure
The images below show the Hyperledger Fabric network infrasctructure that has been developed for this project. The first image shows an overall infrastructure that is scalable in terms of a production system. The second image shows the minimal setup that you can deploy on your machine by using this repository. It consists of three organisations, two manufacturers and one organisation which represents the consumers. These are linked via a Replenishment Hub that is installed in the household of the consumer and a web application. The Hub is responsible to receive sensor data for IoT-devices that measure the actual need of the products. The consumer is able to configure the threshold for a reorder through the web app for every connected device (e.g. filled up to 30%). Also, the consumer is able to connect any poduct of any manufacturer with an IoT-device. This means that this product will get ordered as soon as the reordering threshold gets hit.

### Overall Hyperledger Fabric Network
![Overall Hyperledger Fabric Network](https://user-images.githubusercontent.com/38671044/141429032-48c299b0-fad0-49ce-94ca-cd87dd67338d.png)

### Minimal setup that this repository will deploy
![Minimal setup that this repository will deploy](https://user-images.githubusercontent.com/38671044/141429180-298466a5-0e14-4454-9078-c1588c23257f.png)

## How-To-Use
