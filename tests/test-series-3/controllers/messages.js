'use strict';

const aws = require('aws-sdk');
const db = new aws.DynamoDB({region: "ap-southeast-2"}); 
const parse = require('co-body');
const bluebird = require('bluebird');
const table = "node-perf-baseline";
const prettyHrtime = require('pretty-hrtime');

bluebird.promisifyAll(Object.getPrototypeOf(db));

module.exports = {};

module.exports.fetch = function * (){

    const ctx = this; 

    const params = {
        "IndexName": "recipientIndex",
        "KeyConditions": {
            "recipientUserId": {
                "AttributeValueList": [ { "N": "27426684" } ],
                    "ComparisonOperator": "EQ"
            }
        },
        "Limit": 100,
        "ScanIndexForward": false,
        "TableName": "candidate-comms-communications"
    };

    try{
        const start = process.hrtime();
        const o = yield db.queryAsync(params);
        this.body = o;
        console.log('elapsed', prettyHrtime(process.hrtime(start)));
    }
    catch (e){
        console.error({ message: 'error when reading from database', e: e })
        ctx.throw(500);
    }
}
