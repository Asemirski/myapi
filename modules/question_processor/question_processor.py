from pydantic import BaseModel
from openai import OpenAI
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient


class Question(BaseModel):
    question: str

class QuestionProcessor:
    def __init__(self, key_vault_url):
        credential = DefaultAzureCredential()

        # Initialize key vault client
        client = SecretClient(vault_url=key_vault_url, credential=credential)

        self.openai_api_key = client.get_secret('openai-api-key').value
        self.openai_client = OpenAI(api_key=self.openai_api_key)

    def aiRquest(self, systemPrompt, userPrompt):
        response = self.openai_client.chat.completions.create(
            model="gpt-4",
            messages=[
                {
                    "role": "system",
                    "content": systemPrompt
                },
                {
                    "role": "user",
                    "content": userPrompt.question
                }
            ]
        )

        return response.choices[0].message.content

    def processQuestion(self, userPrompt):
        systemPrompt = "I'm capable to answer to user questions using my general knowledge. Answers should be in Polish language."

        return self.aiRquest(systemPrompt, userPrompt)
