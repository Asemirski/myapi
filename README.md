# myapi
This is an example of basic api service using FastAPI and OpenAI. It simply returns answers in Polish language to the provided questions using gpt-4 model knowledge and 'short-term' memory.
Short-term memory was implemented to cover course's task needs that is to store conversation data untill question is asked.

## Prerequisites
### Tools
1. python3
2. Azure Subscription
3. az cli
4. terraform

### Local development
#### Infrastructure
1. Azure Key Vault with a secret called 'openai-api-key'

### To run app in Azure cloud
#### Infrastructure
1. Azure Key Vault with a secret called 'openai-api-key'
2. Linux Web App with python3 runtime and configured access to the Key Vault
3. (Optional) Vnet and service/private endpoints for security.

## Infrastructure deployment
To deploy required infrastructure, go to `iac` folder and execute the following commands:
```
az login
cd iac
terraform init
terraform apply -var="{IP_ADDRESS_OF_YOUR_MACHINE}" -var="openai_api_key={OPENAI_API_KEY}" -auto-approve
```
Terraform will deploy all the required infra and you'll need only to deploy the app.

To destroy the infra run the following command:
```
terraform destroy -var="{IP_ADDRESS_OF_YOUR_MACHINE}" -var="openai_api_key={OPENAI_API_KEY}" -auto-approve
```
> **_NOTE:_**
Current configuration exposes Key Vault only to web app subnet and to the provided local machine IP address.


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
