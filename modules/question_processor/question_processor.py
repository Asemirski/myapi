from pydantic import BaseModel
from openai import OpenAI
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
import json


class Question(BaseModel):
    question: str


class QuestionProcessor:
    def __init__(self, key_vault_url):
        credential = DefaultAzureCredential()
        # Initialize key vault client
        client = SecretClient(vault_url=key_vault_url, credential=credential)
        self.openai_api_key = client.get_secret('openai-api-key').value
        self.openai_client = OpenAI(api_key=self.openai_api_key)
        self.memory = []

    def storeInformation(self, information):
        self.memory.append(information)

        return self.memory

    def purgeMemory(self):
        self.memory.clear()

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

    # Process user input
    def formatConversationData(self, userPrompt):
        systemPrompt = """
            I'm able to process user message and return the appropriate cathegory of the request.
            Available cathegories are: question and information.
            In case user asks question return JSON only of the following format {\"question\": \"user_question\"}
            In case user provides information return JSON only of the following format {\"information\": \"user_given_information\"}
        """

        return json.loads(self.aiRquest(systemPrompt, userPrompt))

    def processQuestion(self, userPrompt):
        systemPrompt = f"I'm capable to answer to user questions using my general knowledge and knowledge from context. Return results only in Polish language.\n###CONTEXT\n {self.memory}\n###"

        return self.aiRquest(systemPrompt, userPrompt)
