import uvicorn
from fastapi import FastAPI
import argparse
from modules.question_processor.question_processor import Question
from modules.question_processor.question_processor import QuestionProcessor

# 'msg': 'Provide me the URL to your API (HTTPS) via /answer/ endpoint. I will speak to your assistant for a moment',
# 'hint1': 'I will sent data as JSON, and my question would be inside "question" field',
# 'hint2': 'You have to remember information about previous questions, because I will ask you about them and I will expect correct answers',
# 'hint3': 'Please return the answer in JSON format, with "reply" field!'

parser = argparse.ArgumentParser()
parser.add_argument('key_vault_url', type=str, help='Key vault url')
args = parser.parse_args()

app = FastAPI()
question_processor = QuestionProcessor(args.key_vault_url)


# POST data processing
@app.post("/api/question")
def ask_question(question: Question):
    processedData = question_processor.formatConversationData(question)
    if 'information' in processedData:
        print(question_processor.storeInformation(processedData))
        return {"reply": 'Ok. Got it.'}

    elif 'question' in processedData:
        print('processing question...')
        reply = question_processor.processQuestion(userPrompt=question)
        question_processor.purgeMemory()
        return {"reply": reply}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
