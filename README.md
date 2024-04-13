# myapi
This is an example of basic api service using FastAPI and OpenAI.

## Prerequisites
### Required Infrastructure
1. Azure Key Vault
2. Azure Web App
3. Optional: vnet and private/service endpoints for security

### Required secrets
1. OpenAI API key stored in Key Vault

## Usage
To run service locally execute the following command:
```
python3 main.py 'KEY_VAULT_URL'
```
Add the command above to the Web App startup command box to run service in a Web App.
