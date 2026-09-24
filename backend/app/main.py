from fastapi import FastAPI, UploadFile, File
from fastapi.staticfiles import StaticFiles
from app.models.story import StartStoryRequest, ContinueStoryRequest, PageNode
from app.services.llm_service import LLMNarrativeService
from app.services.image_service import ImageGenerationService
from app.services.tts_service import TextToSpeechService

app = FastAPI(title="LuminaTales Engine API")

app.mount("/static", StaticFiles(directory="static"), name="static")

llm_service = LLMNarrativeService()
image_service = ImageGenerationService()
tts_service = TextToSpeechService()

@app.post("/api/v1/story/start", response_model=PageNode)
async def start_story(req: StartStoryRequest):
    page_data = await llm_service.generate_initial_page(req.child_name, req.theme, req.age_group)
    img_url = await image_service.generate_illustration(page_data['image_prompt'])
    audio_url = await tts_service.generate_speech(page_data['narrative_text'])
    
    page_data['image_url'] = img_url
    page_data['audio_url'] = audio_url
    return page_data

@app.post("/api/v1/story/continue", response_model=PageNode)
async def continue_story(req: ContinueStoryRequest):
    page_data = await llm_service.generate_next_page(
        previous_text="Child progressed in narrative.",
        choice_taken=req.selected_choice_id,
        page_num=req.current_page_id + 1
    )
    img_url = await image_service.generate_illustration(page_data['image_prompt'])
    audio_url = await tts_service.generate_speech(page_data['narrative_text'])
    
    page_data['image_url'] = img_url
    page_data['audio_url'] = audio_url
    return page_data

@app.post("/api/v1/voice/clone")
async def record_voice_sample(file: UploadFile = File(...)):
    file_path = f"static/audio/user_voice_{file.filename}"
    with open(file_path, "wb") as f:
        f.write(await file.read())
    return {"status": "success", "voice_profile_id": file_path}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
