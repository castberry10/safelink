# Backend

Node.js/Express API server for SafeLink. Receives URL analysis requests from the mobile app, fetches and analyzes page content using Gemini AI, and returns a safety verdict.

- **Port:** `11112`
- **Database:** PostgreSQL via Prisma ORM
- **API base path:** `/api`

---

## Prerequisites

| Software | Minimum Version |
|----------|----------------|
| [Docker](https://docs.docker.com/get-docker) | any recent version |

---

## Setup

### 1. Create the `.env` file

Copy `.env.example` to `.env` inside the `backend/` folder, or create `.env` with the following content:

```
GEMINI_API_KEY=your_key_here
```

To obtain a Gemini API key:
1. Go to [https://aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey) and sign in with a Google account.
2. Click **Create API key** and copy it.
3. Replace `your_key_here` with the copied key.

### 2. Start the server

```bash
docker-compose up --build -d
```

This builds the Node.js server image, starts a PostgreSQL container, runs all database migrations, and launches the server — all in one command.

The server is available at `http://localhost:11112`.

---

## Directory Structure

```
backend/
├── prisma/
│   ├── schema.prisma               # Database schema
│   └── migrations/                 # Migration history
├── src/
│   ├── index.js                    # Express entry point
│   ├── db.js                       # Prisma client
│   └── api/
│       ├── check/                  # Phishing detection endpoint
│       │   ├── index.js
│       │   ├── check.service.js
│       │   ├── preprocess_html.module.js
│       │   └── safelink_prompt.json      # Gemini prompt
│       ├── system/                 # App version management
│       └── user/                   # User authentication endpoints
├── Dockerfile                      # Node.js server image
├── docker-compose.yml              # DB + server orchestration
└── package.json
```

---

## Prompt

The Gemini prompt is defined in `src/api/check/safelink_prompt.json`. It instructs Gemini to classify the target URL as safe (`1`), suspicious (`2`), or phishing (`3`) and return a user-friendly explanation. For suspicious cases, it additionally enforces the Warning-case explanation rule: the explanation describes only what the site appears to be and quotes text literally visible on the page, without cautionary or risk-amplifying language.

---

## API Endpoints

### Phishing Detection — `/api/check`

Accepts the target URL via query parameter `?websiteUrl=`.

| Method | Path | Description |
|--------|------|-------------|
| GET | `/check/page-content` | Fetches page HTML and runs Gemini AI content analysis |

**Result codes:** `1` = safe, `2` = suspicious, `3` = phishing

**`/check/page-content` flow:**
1. Follow redirects and fetch the page HTML
2. Extract and compress text nodes from the HTML tree
3. Hash the URL + HTML with SHA-256 and check the cache
4. On cache hit: return immediately. On miss: call Gemini AI, store result in cache.

---

### Authentication — `/api/users`

Username-only registration with no password.

| Method | Path | Description |
|--------|------|-------------|
| POST | `/users/register` | Register a new user |
| POST | `/users/login` | Sign in an existing user |

---

### Version Check — `/api/system`

| Method | Path | Description |
|--------|------|-------------|
| POST | `/system/version` | Returns `426` if the client version is below the minimum threshold |

---

## Database Schema

### `users`
App users identified by username.

| Column | Type | Description |
|--------|------|-------------|
| `username` | String (unique) | Display name |

### `Cache`
Stores Gemini AI analysis results keyed by URL + HTML hash pair.

| Column | Type | Description |
|--------|------|-------------|
| `urlHash` | String (SHA-256) | Hash of the request URL |
| `htmlHash` | String (SHA-256) | Hash of the fetched HTML |
| `data` | JSON | Full AI analysis result |
