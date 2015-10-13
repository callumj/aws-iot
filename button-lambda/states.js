var AWS = require('aws-sdk');
var dynamodb = new AWS.DynamoDB({apiVersion: '2012-08-10'});

var config = require('./config.json');

exports.handler = function(event, context) {
    console.log('Received event:', JSON.stringify(event, null, 2));

    var data = {
        "TableName": config.DYNAMODB_TABLE,
        "Item": {
            "DeviceIdentifier": {"S": event.deviceId},
            "State": {"S": event.state}
        }
    };
    dynamodb.putItem(data, context.done)
};