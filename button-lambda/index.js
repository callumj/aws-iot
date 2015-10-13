var AWS = require('aws-sdk');
AWS.config.update({region:'us-east-1'});
var dynamodb = new AWS.DynamoDB({apiVersion: '2012-08-10'});

var request = require('request');

var config = require('./config.json')

var controlLight = function(object, context) {
  var ops = "lights_on";
  if (object == null || object.Item.State.S == "ON") {
    ops = "lights_off"
  }

  console.log("Performing " + ops + ":", object);
  request('https://maker.ifttt.com/trigger/' + ops + '/with/key/' + config.IFTTT_MAKER_KEY, function (error, response, body) {
    console.log("Request completed: ", response.statusCode);
    context.done();
  });
}

// Called when the AWS IoT button is pressed
exports.handler = function(event, context) {
    if (event.clickType != "SINGLE") {
      return;
    }

    // ask DynamoDB for the current state
    var item = dynamodb.getItem({
      Key: {"DeviceIdentifier": {"S": config.DYNAMODB_KEY}},
      TableName: config.DYNAMODB_TABLE,
    }, function(err, data) {
      if (err) console.log(err, err.stack); // an error occurred
      else     controlLight(data, context);           // successful response
    });
};