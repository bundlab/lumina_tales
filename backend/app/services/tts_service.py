import os
import uuid

class TextToSpeechService:
    def __init__(self):
        os.makedirs("static/audio", exist_ok=True)

    async def generate_speech(self, text: str, voice_speaker: str = "p225") -> str:
        filename = f"static/audio/speech_{uuid.uuid4().hex[:8]}.wav"

        import wave, struct, math
        with wave.open(filename, 'w') as wav:
            wav.setparams((1, 2, 22050, 0, 'NONE', 'not compressed'))
            for i in range(22050 * 2):
                value = int(32767.0 * math.sin(2.0 * math.pi * 440.0 * i / 22050))
                wav.writeframes(struct.pack('h', value))

        return f"http://localhost:8000/{filename}"
