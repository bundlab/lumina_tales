import google.generativeai as genai
import json
import os

class LLMNarrativeService:
    def __init__(self):
        genai.configure(api_key=os.getenv("GEMINI_API_KEY", "YOUR_GEMINI_API_KEY"))
        self.model = genai.GenerativeModel('gemini-1.5-flash')

    async def generate_initial_page(self, child_name: str, theme: str, age_group: int) -> dict:
        prompt = f"""
        You are a magical storyteller writing an interactive story for a {age_group}-year-old named {child_name}.
        Theme: {theme}.

        Return JSON matching this exact structure:
        {{
            "page_id": 1,
            "narrative_text": "Story text (3-4 friendly sentences)...",
            "image_prompt": "Children's storybook illustration style, colorful, vibrant, digital art: detailed prompt matching narrative...",
            "choices": [
                {{"id": "c1", "text": "Choice 1 text", "action_prompt": "What happens next option 1"}},
                {{"id": "c2", "text": "Choice 2 text", "action_prompt": "What happens next option 2"}}
            ]
        }}
        Output ONLY valid JSON.
        """
        response = self.model.generate_content(prompt)
        cleaned_text = response.text.replace('```json', '').replace('```', '').strip()
        return json.loads(cleaned_text)

    async def generate_next_page(self, previous_text: str, choice_taken: str, page_num: int) -> dict:
        prompt = f"""
        Continue the story based on previous event: "{previous_text}" and choice taken: "{choice_taken}".
        
        Return JSON matching this exact structure:
        {{
            "page_id": {page_num},
            "narrative_text": "Story text...",
            "image_prompt": "Children's storybook illustration style: detailed prompt...",
            "choices": [
                {{"id": "c1", "text": "Choice 1 text", "action_prompt": "Option 1"}},
                {{"id": "c2", "text": "Choice 2 text", "action_prompt": "Option 2"}}
            ]
        }}
        Output ONLY valid JSON.
        """
        response = self.model.generate_content(prompt)
        cleaned_text = response.text.replace('```json', '').replace('```', '').strip()
        return json.loads(cleaned_text)
