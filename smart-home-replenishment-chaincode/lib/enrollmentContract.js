'use strict'

const { Contract } = require('fabric-contract-api');

class EnrollmentContract extends Contract {

    constructor() {
        super('smartreplenishment.contracts.enrollment');
    }

    async enrollConsumer(ctx, identity, org) {

    }

    async enrollManufacturer(ctx, identity, org) {

    }
}


module.exports = EnrollmentContract;