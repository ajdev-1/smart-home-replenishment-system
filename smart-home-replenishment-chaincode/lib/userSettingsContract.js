'use strict'

const { Contract } = require('fabric-contract-api');

class UserSettingsContract extends Contract {

    constructor() {
        super('smartreplenishment.contracts.usersettings');
    }

    /**
     * Sets the threshold that will trigger an ordering process when the
     * trasmitted sensor data for the specified iotdevice is overreaching.
     * Also adds the product that will get reordered.
     * 
     * @param {*} ctx 
     * @param {*} name 
     * @param {*} org 
     * @param {*} consumer 
     * @param {*} threshold 
     * @param {*} iotdevice 
     * @returns 
     */
    async setReorderPolicy(ctx, name, org, consumer, threshold, iotdevice) {
        console.log(`Starting to create reorder policy for consumer ${consumer} and iotdevice ${iotdevice}.`);
        const productId = `product-${name}-${org}`;
        const reorderPolicyId = `reorder-policy-${name}-${org}-${iotdevice}`;

        const reorderPolicy = await ctx.stub.getState(reorderPolicyId)

        if (!reorderPolicy || reorderPolicy.length === 0) {
            console.info('Creating new reorder policy...');

            reorderPolicy = {
                id: reorderPolicyId,
                productId: productId,
                iotdevice: iotdevice,
                consumer: consumer,
                threshold: threshold
            }

            console.info(`Adding reorder policy with id ${newReorderPolicy.id} to the ledger:`, newReorderPolicy);
            ctx.stub.putState(newReorderPolicy.id, Buffer.from(JSON.stringify(newReorderPolicy)));

        } else {
            console.info(`Found existing reorder policy with id ${reorderPolicyId}. 
                Setting new threshold ${threshold} or iotdevice ${iotdevice}.`, reorderPolicy);

            reorderPolicy.threshold = threshold || reorderPolicy.threshold;
            reorderPolicy.iotdevice = iotdevice || reorderPolicy.iotdevice;
        }

        return JSON.stringify(reorderPolicy);
    }
}


module.exports = UserSettingsContract;