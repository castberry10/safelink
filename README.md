# SafeLink

This is the official implementation of the paper **SafeLink: Uncertainty-Aware Mobile Phishing Defense with a Stabilized LLM-Assisted Agent**.

SafeLink is a mobile phishing-defense application for QR-code and mobile-link workflows.
When a user scans a QR code or opens a mobile link, SafeLink resolves redirects, normalizes URL and HTML evidence, and uses a stabilized LLM-assisted semantic analysis pipeline to map the page to one of three outcomes: Safe, Warning, or Danger. Safe pages can proceed to the browser, Warning pages require user confirmation with an explanation, and Danger pages are blocked.

> **Publication status:** Accepted at the **42nd Annual Computer Security Applications Conference (ACSAC 2026)**, December 7–11, 2026, Los Angeles, California, USA.
>
> **Authors:** Wonyeong Choi, Jiyeong Park, Joonsik An, Dayeon Jeong, Kyeongpil Kang, Woojoo Kim, and Dayoung Lee.

This repository contains the implementation artifact and supplementary user study materials.

---

## Repository Contents

```
safelink/
├── user_study/                            # Materials and analysis codebooks from the user evaluations
│   ├── formative_study/                   # Phase 1: in-person study (N=12)
│   │   ├── formative_study_materials.md   # Tasks, stimuli, and questionnaire used in the study
│   │   ├── formative_study_codebook.md    # Codebook for semi-structured interview responses
│   │   └── formative_study_workflow.pdf   # Study procedure workflow diagram
│   └── summative_study/                   # Phase 2: online study (N=30)
│       ├── summative_study_materials.md   # Tasks, stimuli, and response format used in the study
│       ├── summative_study_codebook.md    # Codebook for written rationales on Warning-category URLs
│       └── summative_study_workflow.pdf   # Study procedure workflow diagram
├── backend/                               # Node.js/Express API server
├── safelink_app/                          # Flutter mobile application
└── LICENSE
```

| Path | Description |
|------|-------------|
| `user_study/` | Supplementary study materials. See [User Study Materials](#user-study-materials) below. |
| `backend/` | REST API server. Handles URL analysis and result caching via Google Gemini. See [backend/README.md](backend/README.md). |
| `safelink_app/` | Flutter Android app. Handles URL/QR input and displays AI analysis results. See [safelink_app/README.md](safelink_app/README.md). |

---

## User Study Materials

The `user_study/` folder contains supplementary materials from two phases of user evaluation.

### Phase 1 — Formative Study (`formative_study/`)

An in-person study with N=12 participants. Participants scanned 16 QR codes using a Galaxy S25 device with SafeLink installed, then rated each link on a 7-point Likert safety scale and made a proceed/avoid decision. A post-study questionnaire and semi-structured interview were conducted after all trials.

| File | Description |
|------|-------------|
| `formative_study_materials.md` | Full study protocol: participant onboarding, 16-item stimulus set with SafeLink classifications and explanations, post-study questionnaire (11 items across 4 dimensions), and semi-structured interview questions |
| `formative_study_codebook.md` | Inductive codebook for analyzing qualitative interview responses from the semi-structured interviews |
| `formative_study_workflow.pdf` | Workflow diagram illustrating the formative study procedure |

### Phase 2 — Summative Study (`summative_study/`)

An online anonymous survey with N=30 participants. Participants judged 10 Warning-category URLs — selected to span both benign and phishing ground truth — and provided written rationales for each judgment. The study examines whether users can resolve Warning outcomes and evaluates the refined Warning-case explanation rule.

| File | Description |
|------|-------------|
| `summative_study_materials.md` | Full study protocol: participant onboarding (including phishing definition criteria), 10-item Warning stimulus set, and binary response + open-ended justification format |
| `summative_study_codebook.md` | Codebook for written rationales, organized by TP / FN / TN / FP classification across 300 responses |
| `summative_study_workflow.pdf` | Workflow diagram illustrating the summative study procedure |

---

## Architecture

```
Mobile Client (Flutter)
        │  QR/URL input
        ▼
Backend Server (Node.js + Express)
        │
        ├── Redirect Resolution
        ├── Domain Canonicalization
        ├── HTML Normalization
        ├── Content-Level Decision Cache  ── PostgreSQL (Docker)
        ├── LLM-Assisted Semantic Analysis ── Google Gemini
        ▼
Policy-Controlled Decision Engine
        │
        ├── Safe: proceed to browser
        ├── Warning: show explanation and ask user to decide
        └── Danger: block access
```

---

## Quick Start

### 1. Start the backend server

Install Docker from [https://docs.docker.com/get-docker](https://docs.docker.com/get-docker), then see [backend/README.md](backend/README.md) for prerequisites and detailed instructions.

```bash
cd backend
# Fill in GEMINI_API_KEY in .env first
docker-compose up --build -d
```

### 2. Run the Flutter app

See [safelink_app/README.md](safelink_app/README.md) for prerequisites and detailed instructions.

```bash
cd safelink_app
# Fill in SERVER_URL in .env first
flutter pub get
flutter run
```

---

## Citation

If you use SafeLink or the user study materials in your research, please cite:

```bibtex
@inproceedings{choi2026safelink,
  title     = {{SafeLink}: Uncertainty-Aware Mobile Phishing Defense
               with a Stabilized {LLM}-Assisted Agent},
  author    = {Choi, Wonyeong and Park, Jiyeong and An, Joonsik and
               Jeong, Dayeon and Kang, Kyeongpil and Kim, Woojoo and
               Lee, Dayoung},
  booktitle = {Proceedings of the 42nd Annual Computer Security
               Applications Conference (ACSAC)},
  year      = {2026}
}
```

---

## License

This project is licensed for **academic and research use only**. Commercial use, redistribution, and derivative works are prohibited. See [LICENSE](LICENSE) for full terms.