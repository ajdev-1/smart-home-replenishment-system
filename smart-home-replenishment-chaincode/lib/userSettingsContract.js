'use strict'

const { Contract } = require('fabric-contract-api');

class UserSettingsContract extends Contract {

    constructor() {
        super('smartreplenishment.contracts.usersettings');
    }

    /**
     * Sets the threshold that will trigger an ordering process when the
     * trasmitted sensor data for the specified iotdevice is overreaching.
     * 
     * @param {Object} ctx 
     * @param {Number} threshold 
     * @param {String} iotdevice 
     */
    async setReorderThreshold(ctx, threshold, iotdevice) {

    }

    /**
     * Sets the product that will be reordered as soon as the threshold on the
     * iotdevice is met.
     * 
     * @param {*} ctx 
     * @param {*} productId 
     * @param {*} iotdevice 
     */
    async setReorderProduct(ctx, productId, iotdevice) {

    }
}


module.exports = UserSettingsContract;