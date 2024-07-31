import boto3
import requests
import json
from os import environ

def get_secret(secret_arn):
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=secret_arn)
    return json.loads(response['SecretString'])

def prepare_auth_data(secret, company_code, secret_prefix):
    username_key = f"{secret_prefix}_username"
    pw_key = f"{secret_prefix}_pw"
    return {
        "userName": secret[username_key],
        "passWord": secret[pw_key],
        "companyCode": company_code,
        "operatingSystem": 3
    }

def make_auth_request(url, data):
    headers = {"Content-Type": "application/json"}
    response = requests.post(url, headers=headers, json=data)
    return response.json()

def handler(event, context):
    secret_arn = environ['SECRET_ARN']
    auth_url = environ['AUTH_URL']
    company_code = environ['COMPANY_CODE']
    secret_prefix = environ['SECRET_PREFIX']

    secret = get_secret(secret_arn)
    auth_data = prepare_auth_data(secret, company_code, secret_prefix)
    response_data = make_auth_request(auth_url, auth_data)

    auth_token = response_data["authToken"]
    print(auth_token)

    return {"authToken": auth_token}