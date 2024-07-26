import requests
from os import environ
from aws_lambda_powertools.utilities import parameters

def lambda_handler(event, context):
    # Retrieve secret data from AWS Secrets Manager
    secret = parameters.get_secret(environ.get('secret_arn'), transform='json', max_age=60)

    # Get environment variables for the API request
    url = environ.get('auth_url')
    company_code = environ.get('company_code')
    secretPrefix = environ.get('secret_prefix')
    username_key = secretPrefix + "_username"
    pw_key = secretPrefix + "_pw"

    # Extract username and password from the retrieved secret
    username = secret.get(username_key)
    password = secret.get(pw_key)

    # Prepare the headers and data for the API request
    headers = {
        "Content-Type": "application/json"
    }
    data = {
        "userName": username,
        "passWord": password,
        "companyCode": company_code,
        "operatingSystem": 3
    }

    # Make the POST request to the authentication URL
    response = requests.post(url, headers=headers, json=data)
    responseData = response.json()

    # Extract the authentication token from the response
    authToken = responseData["authToken"]
    print(authToken)

    return {"authToken": authToken}
