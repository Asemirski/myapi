import uvicorn
from fastapi import FastAPI

from modules.question_processor.question_processor import Question
from modules.question_processor.question_processor import QuestionProcessor

app = FastAPI()
processor = QuestionProcessor()

@app.post("/api/question")
async def ask_question(question: Question):
    print(question)
    return {"reply": processor.processQuestion(userPrompt=question)}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
