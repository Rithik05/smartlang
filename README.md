# 📖 SmartLang

**SmartLang** is an AI-powered application that leverages advanced language models via APIs to provide seamless text translation and PDF summarization services.

---

## ✨ Features

- 🌍 **Text Translation**
  - Translate text instantly between multiple languages.
  - Uses Google translate API to provide contextually accurate and fluent translations.

- 📄 **PDF Summarization**
  - Upload PDF documents and receive concise summaries of the content.
  - Ideal for quickly digesting lengthy reports, articles, and research papers.

---

## 📦 Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/smartlang.git
```
## Prerequisites
Install Poppler:
For MacOS
```bash
brew install poppler
pdftotext -v
```
For Linux
```bash
sudo apt update
sudo apt install poppler-utils
pdftotext -v
```

## Setup
Setup DB:
```bash
source .env.dev
mix deps.get
mix ecto.setup
```

generate static build from frontend
```bash
cd assets/frontend
npm i
npm run build
```

run phx server from smartlang dir
```bash
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
