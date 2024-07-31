import json
import requests
import os

def handler(event, context):
    api_key = os.environ['API_KEY']
    city = os.environ['CITY']
    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}"

    response = requests.get(url)
    data = response.json()

    return {
        'statusCode': 200,
        'body': json.dumps(data)
    }