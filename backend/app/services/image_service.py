import torch
from diffusers import StableDiffusionPipeline
import os
import uuid

class ImageGenerationService:
    def __init__(self):
        self.use_gpu = torch.cuda.is_available()
        if self.use_gpu:
            self.pipe = StableDiffusionPipeline.from_pretrained(
                "runwayml/stable-diffusion-v1-5", torch_dtype=torch.float16
            ).to("cuda")

    async def generate_illustration(self, prompt: str) -> str:
        filename = f"static/img_{uuid.uuid4().hex[:8]}.png"
        os.makedirs("static", exist_ok=True)
        
        if self.use_gpu:
            image = self.pipe(prompt, num_inference_steps=20).images[0]
            image.save(filename)
        else:
            from PIL import Image, ImageDraw
            img = Image.new('RGB', (512, 512), color=(135, 206, 235))
            d = ImageDraw.Draw(img)
            d.text((10, 10), f"Illustration:\n{prompt[:60]}...", fill=(255, 255, 255))
            img.save(filename)

        return f"http://localhost:8000/{filename}"
