# 📚 LuminaTales: Interactive AI Storybook & Audio Generator

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter)](https://flutter.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.110%2B-009688?logo=fastapi)](https://fastapi.tiangolo.com)
[![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?logo=python)](https://www.python.org)

**LuminaTales** is an interactive, multi-modal storybook application designed for children. Combining real-time narrative generation via Large Language Models (LLMs), dynamic visual generation through Stable Diffusion, and natural voice text-to-speech (TTS), LuminaTales turns reading into an immersive, choose-your-own-adventure audio-visual experience.

---

## 🌟 Key Features

* **📖 Interactive Story Branching:** Dynamic narrative generation tailored to the child's name, age group, and chosen adventure theme.
* **🎨 Real-Time Illustration Engine:** Custom visual book pages generated on the fly via Stable Diffusion matching story events.
* **🔊 Tap-to-Listen Audio Synthesis:** Real-time character voice synthesis rendering natural-sounding narration for early readers.
* **🎙️ Voice Recording & Profile Setup:** Support for parent/user voice sampling to personalize reading voices.
* **📱 Rich Flutter Reader UI:** Child-friendly interface featuring tap controls, animations, and decision-tree controls.

---

## 🏗️ System Architecture

```
                              +-----------------------+
                              | Flutter Mobile Reader |
                              |   (Android / iOS)     |
                              +-----------+-----------+
                                          |
                               REST API   |  HTTP/JSON
                                          v
                              +-----------------------+
                              |   Python FastAPI      |
                              | Orchestration Engine  |
                              +---+-------+-------+---+
                                  |       |       |
          +-----------------------+       |       +-----------------------+
          |                               |                               |
          v                               v                               v

```

+---------------------+        +---------------------+        +---------------------+
| Gemini / LLM Engine |        |  Stable Diffusion   |        | Coqui / Bark TTS    |
| (Story & Choices)   |        | (Image Generation)  |        | (Audio Generation)  |
+---------------------+        +---------------------+        +---------------------+

```

---

## 📂 Project Structure

```text
lumina_tales/
├── .gitignore
├── README.md
├── backend/                        # Python FastAPI Orchestration Layer
│   ├── app/
│   │   ├── main.py                 # FastAPI Application Entrypoint
│   │   ├── config.py               # Configuration & Environment Variables
│   │   ├── models/                 # Pydantic Data Models
│   │   │   ├── story.py            # Story Node & Request Schemas
│   │   │   └── audio.py            # Audio Profile Schemas
│   │   └── services/               # AI Service Integrations
│   │       ├── llm_service.py      # Narrative Arc & Choice Synthesis
│   │       ├── image_service.py    # Stable Diffusion Pipeline
│   │       └── tts_service.py      # Text-To-Speech Synthesis Engine
│   └── requirements.txt            # Python Dependencies
│
└── frontend/                       # Flutter Mobile Application
    ├── lib/
    │   ├── main.dart               # Flutter App Initialization & Entrypoint
    │   ├── models/                 # Frontend Data Models
    │   ├── providers/              # State Management (Provider Layer)
    │   └── screens/                # Application Screens (Home, Reader)
    └── pubspec.yaml                # Flutter Dependencies & Assets

```

---

## 🚀 Getting Started

### Prerequisites

* **Python 3.10+**
* **Flutter SDK 3.0+**
* **NVIDIA GPU with CUDA support** (Optional, recommended for local Stable Diffusion & TTS generation)
* **Google Gemini API Key**

---

### 1. Backend Setup (FastAPI Engine)

1. Navigate to the backend directory:
```bash
cd backend

```


2. Create and activate a virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

```


3. Install required Python packages:
```bash
pip install -r requirements.txt

```


4. Set your environment variables:
```bash
export GEMINI_API_KEY="your-gemini-api-key-here"

```


5. Launch the FastAPI server:
```bash
python app/main.py

```


The API will be live at `http://localhost:8000`. You can inspect the API documentation at `http://localhost:8000/docs`.

---

### 2. Frontend Setup (Flutter App)

1. Navigate to the frontend directory:
```bash
cd frontend

```


2. Install Flutter packages:
```bash
flutter pub get

```


3. Configure Backend Base URL:
Ensure the `baseUrl` in `lib/providers/story_provider.dart` points to your backend instance:
* **Android Emulator:** `http://10.0.2.2:8000/api/v1`
* **iOS Simulator / Desktop:** `http://localhost:8000/api/v1`
* **Physical Device:** `http://<YOUR_LOCAL_IP>:8000/api/v1`


4. Run the application:
```bash
flutter run

```



---

## 🔌 API Endpoints Summary

| Method | Endpoint | Description |
| --- | --- | --- |
| `POST` | `/api/v1/story/start` | Generates initial story chapter, image prompt, and audio track. |
| `POST` | `/api/v1/story/continue` | Generates next narrative arc step based on user decision branch. |
| `POST` | `/api/v1/voice/clone` | Uploads voice audio sample for personalized TTS profiling. |

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for details.

