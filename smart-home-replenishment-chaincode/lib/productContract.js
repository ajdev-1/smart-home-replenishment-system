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
        console.info(`============= START : Adding product ${name} ===========`);

        const product = {
            id: ctx.stub.createCompositeKey('product', ['name', 'org']),
            name: name,
            price: price,
            description: desc,
            quantity: quantity,
            org: org
        };

        ctx.stub.putState(product.id, Buffer.from(JSON.stringify(product)));

        console.info('============= END : Adding product ===========');
        return JSON.stringify(product);
    }

    /**
     * Returns the corresponding product.
     * 
     * @param {Object} ctx
     * @param {String} productId The product identifier.
     */
    async getProduct(ctx, productId) {
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
        
    }

    /**
     * Orders a product by updating the ledger and notifying the related organisation.
     * 
     * @param {Object} ctx 
     * @param {String} orderer Identity that wants to order the product. 
     * @param {String} productId Identifier for the product to order.
     */
    async orderProduct(ctx, orderer, productId) {

    }
}


module.exports = ProductContract;