# myapi
This is an example of basic api service using FastAPI and OpenAI. It simply returns answers in Polish language to the provided questions using gpt-4 model knowledge.

## Prerequisites
### Required Infrastructure
1. Azure Key Vault
2. Azure Web App
3. Optional: vnet and private/service endpoints for security

### Required secrets
1. OpenAI API key stored in Key Vault called 'openai-api-key'

## Usage
To run service locally execute the following command:
```
python3 main.py 'KEY_VAULT_URL'
```
Add the command above to the Web App startup command box to run service in a Web App.

Questions should be sent to /api/question endpoint, with the following format:
```json
{
    "question": "What's the capital of Poland"
}
```
Service returns following response:
```json
{
    "reply": "Stolicą Polski jest Warszawa."
}
```
