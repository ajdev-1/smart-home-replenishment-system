'use strict'

const { Contract } = require('fabric-contract-api');

class ProductContract extends Contract {

    constructor() {
        super('smartreplenishment.contracts.product');
    }

    /**
     * Adds a new product for a specific organisation to the ledger.
     * 
     * @param {Object} ctx Transaction context that contains APIs for the world state etc.
     * @param {String} name Name of the product.
     * @param {Number} price Price of the product.
     * @param {String} desc Description for the product.
     * @param {Number} quantity Quantity of available pieces.
     * @param {String} org Organisation that the product belongs to.
     */
    async addProduct(ctx, name, price, desc, quantity, org) {
        const product = {
            // id: ctx.stub.createCompositeKey('product', [name, org]),
            id: `product-${name}-${org}`,
            name: name,
            price: price,
            description: desc,
            quantity: quantity,
            org: org
        };

        console.info(`Adding product with id ${product.id} to the ledger:`, product);
        ctx.stub.putState(product.id, Buffer.from(JSON.stringify(product)));

        return JSON.stringify(product);
    }

    /**
     * Returns the corresponding product.
     * 
     * @param {Object} ctx
     * @param {String} name The name of the product.
     * @param {String} org The org, the product belongs to.
     */
    async getProductByNameAndOrg(ctx, name, org) {
        // const productId = ctx.stub.createCompositeKey('product', ['name', 'org']);
        const productId = `product-${name}-${org}`;

        console.info(`Trying to get product with id ${productId}.`)
        const product = await ctx.stub.getState(productId);

        if (!product || product.length === 0) {
            throw new Error(`Could not retrieve the product with id ${productId}`);
        }

        return product.toString();
    }

    /**
     * Gets an organisation identifier and retrieves all of its products.
     * 
     * @param {Object} ctx 
     * @param {String} org The organisation that contains the products.
     */
    async listProducts(ctx, org) {
        console.log(`Starting to list products for org ${org}.`)
        const products = [];

        const productIterator = await ctx.stub.getStateByRange('','');
        let result = await productIterator.next();

        console.log('Next product from product iterator next() call:', result);

        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }

            console.log('Trying to get product, current product', result.value.key, record);
            if (result.value.key.includes('product') && result.value.key.includes(org)) {
                products.push({ Key: result.value.key, Record: record });
            }

            result = await productIterator.next();
        }

        console.info('Returning products...', products);

        return JSON.stringify(products);
    }

    /**
     * Orders a product by updating the ledger and notifying the related organisation.
     * 
     * @param {Object} ctx 
     * @param {String} orderer Identity that wants to order the product. 
     * @param {String} name The name of the product.
     * @param {String} org The org, the product belongs to.
     */
    async orderProduct(ctx, orderer, name, org) {
        // const productId = ctx.stub.createCompositeKey('product', ['name', 'org']);
        const productId = `product-${name}-${org}`;

        const productBuffer = await ctx.stub.getState(productId);
        let product1 = productBuffer.toString('utf8').replace(/\\/g, '');

        console.log('LOG1', typeof product1);
        console.log('LOG1', product1);

        const product = JSON.parse(product1);

        console.log('LOG1', typeof product);
        console.log('LOG1', product);

        if (product) {
            console.info(`Found asset with id ${productId} and quantity ${product.quantity}:`, product);

            // Change product quantity
            if (parseInt(product.quantity) > 0) {
                const newQuantity = parseInt(product.quantity) - 1;
                product.quantity = newQuantity.toString();
            } else {
                throw new Error(`Product quantity for product with ${productId} is exhausted.`);
            }

            // Notify organisation about new order
            const eventPayload = {
                orderedProduct: name,
                orderer: orderer
            };
            ctx.stub.setEvent(`new-order-${org}-${name}-${orderer}`, eventPayload);

            // Update ledger with new product state
            console.info(`Updating product with id ${productId} with new quantity ${product.quantity}...`);
            return ctx.stub.putState(productId, Buffer.from(JSON.stringify(product)));
        } else {
            throw new Error(`Asset with id ${productId} does not exist.`);
        }
    }
}


module.exports = ProductContract;