from pydantic import BaseModel
from typing import List, Optional

class ChoiceOption(BaseModel):
    id: str
    text: str
    action_prompt: str

class PageNode(BaseModel):
    page_id: int
    narrative_text: str
    image_prompt: str
    image_url: Optional[str] = None
    audio_url: Optional[str] = None
    choices: List[ChoiceOption] = []

class StartStoryRequest(BaseModel):
    child_name: str
    theme: str
    age_group: int

class ContinueStoryRequest(BaseModel):
    story_id: str
    current_page_id: int
    selected_choice_id: str
