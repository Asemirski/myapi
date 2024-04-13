import uvicorn
from fastapi import FastAPI
import argparse

from modules.question_processor.question_processor import Question
from modules.question_processor.question_processor import QuestionProcessor

parser = argparse.ArgumentParser()
parser.add_argument('key_vault_url', type=str, help='Key vault url')
args = parser.parse_args()

app = FastAPI()
processor = QuestionProcessor(args.key_vault_url)

@app.post("/api/question")
async def ask_question(question: Question):
    print(question)
    return {"reply": processor.processQuestion(userPrompt=question)}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
