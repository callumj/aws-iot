## AWS IoT examples

This repo contains code for interacting with the AWS IoT platform.


### button-lambda

This project involves the use of the AWS IoT Button (https://aws.amazon.com/iot/button/) to control a Belkin Wemo Insight Switch connected via IFTTT. To allow for efficient toggling on/off using the same pres we use DynamoDB to keep track of when the light turns off and on, which is a another set of IFTTT Maker + Wemo recipes.


The `config.json` looks something like this:

```
{
  "IFTTT_MAKER_KEY": "SOME_KEY",
  "DYNAMODB_KEY": "DeskLamp",
  "DYNAMODB_TABLE": "DeviceStates"
}
```