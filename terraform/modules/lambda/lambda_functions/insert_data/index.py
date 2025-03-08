
import json
import boto3

# Initialize the EventBridge client
eventbridge_client = boto3.client('events')

# Event bus name (make sure it matches the one you created)
eventbus_name = 'example-event-bus'

def lambda_handler(event, context):
    try:
        # Check if event is from an API Gateway or direct test (body exists)
        if 'body' in event:
            body = json.loads(event['body'])
        # Check if event is from SQS (contains Records)
        elif 'Records' in event:
            body = json.loads(event['Records'][0]['body'])
        else:
            raise ValueError("Event body is missing in the request.")
        
        # Check if the required fields are in the body
        required_fields = ['client-name', 'client-number', 'client-type']
        for field in required_fields:
            if field not in body:
                raise ValueError(f"Missing field: {field}")
        
        # Extract client details
        client_name = body['client-name']
        client_number = body['client-number']
        client_type = body['client-type']

        # Define the event detail for EventBridge
        event_detail = {
            'client-name': client_name,
            'client-number': client_number,
            'client-type': client_type
        }

        # Send the event to the EventBridge event bus
        response = eventbridge_client.put_events(
            Entries=[
                {
                    'Source': 'lambda-client',
                    'DetailType': 'client-details',
                    'Detail': json.dumps(event_detail),
                    'EventBusName': eventbus_name
                }
            ]
        )

        # Log the response from EventBridge (optional)
        print("Event sent to EventBridge:", response)

        # Return success response
        return {
            'statusCode': 200,
            'body': json.dumps('Event sent successfully to EventBridge!')
        }

    except Exception as e:
        # Catch and log any exceptions
        print(f"Error occurred: {str(e)}")
        return {
            'statusCode': 400,
            'body': json.dumps(f"Error occurred: {str(e)}")
        }
