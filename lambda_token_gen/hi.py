import os 

def print_env_vars():
    # Retrieve environment variables
    db_user = os.environ.get('company_code')
    db_password = os.environ.get('secret_prefix')

    print(f"Database User: {db_user}")
    print(f"Database Password: {db_password}")

# Example usage
print_env_vars()
