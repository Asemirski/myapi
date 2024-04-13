# myapi
This is an example of basic api service using FastAPI and OpenAI. It simply returns answers in Polish language to the provided questions using gpt-4 model knowledge and 'short-term' memory.
Short-term memory was implemented to cover course's task needs that is to store conversation data untill question is asked.

## Prerequisites
### Required tools
1. python3
2. az cli
### Required Infrastructure
1. Azure Key Vault
2. Azure Web App
3. Optional: vnet and private/service endpoints for security

### Required secrets
1. OpenAI API key stored in Key Vault called 'openai-api-key'

## Usage
To run service locally execute the following commands:
```
az login # Required to get access to the key vault
pip3 install -r requirements.txt
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
In case a piece of an iformation is given:
```json
{
    "question": "My name is Alex"
}
```
Service saves the info utill a question is asked and returns the following response:
```json
{
    "reply": "Ok. Got it."
}
```
