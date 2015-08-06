'use strict';

const aws = require('aws-sdk');
const db = new aws.DynamoDB({region: "ap-southeast-2"}); 
const parse = require('co-body');
const bluebird = require('bluebird');
const table = "node-perf-baseline";

bluebird.promisifyAll(Object.getPrototypeOf(db));

module.exports = {};

module.exports.create = function * (id){

    const o = yield parse(this);
    const ctx = this; 

    if(!id){
        ctx.throw("need to provide object ID in request");
    }
    
    if(!o.lookup){
        ctx.throw("need to provide object lookup value in request");
    }

    const params = {
        Item: { 
            id: {
                "S": id 
            },
            lookup: {
                "N": o.lookup
            },
            data: {
                "S": JSON.stringify(o)
            }
        },
        TableName: table 
    };

    try{
        console.log('writing', o);
        const w = yield db.putItemAsync(params);
        console.log(w);
        ctx.response.status = 204;
    }
    catch (e){
        console.error({ message: 'error when writing to database', e: e })
        ctx.throw(500);
    }
}

module.exports.fetch = function* (id){

    const ctx = this; 

    if(!id){
        ctx.throw("need to provide object ID in request");
    }

    const params = {
        Key: { 
            id: {
                "S": id 
            },
        },
        TableName: table 
    };

    try{
        const o = yield db.getItemAsync(params);
        console.log('this is o', o.Item.data.S);
        this.body = o.Item.data.S;
    }
    catch (e){
        console.error({ message: 'error when reading from database', e: e })
        ctx.throw(500);
    }
}
