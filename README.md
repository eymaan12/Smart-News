# 📰 Smart News App

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

A mobile application developed for the **CS-473 Mobile Application Development 2** Mid Lab Sessional (Spring 2026). 

Smart News is an intelligent, offline-capable news reader that fetches the latest headlines, provides AI-driven summaries, and performs entirely on-device sentiment analysis to track the emotional tone of the news you consume.

## ✨ Core Features

* **🌐 Live API Integration:** Fetches real-time news articles with infinite scrolling (pagination) capabilities.
* **📶 Robust Offline Functionality (Critical):** Implements local data caching. If the internet connection drops, the app seamlessly loads cached data without crashing. Automatically refreshes data when the connection is restored.
* **🧠 Local Sentiment Analysis:** Analyzes article text to determine if the tone is **Positive**, **Negative**, or **Neutral**. *This is performed 100% locally using custom NLP logic without relying on any external APIs.*
* **🤖 AI Article Summarization:** Generates concise, intelligent summaries of full-length articles (via API/Mock integration).
* **📊 Analytics Dashboard:** A dedicated visualization screen displaying:
    * Total articles processed.
    * Interactive charts breaking down the ratio of Positive, Negative, and Neutral articles.

## 📱 Screenshots
*(Add screenshots of your UI here later: News List, Detail View, and Analytics Dashboard)*

## 🏗️ Architecture & Implementation Details

### 1. On-Device Sentiment Analysis Logic
To meet the requirement of zero API usage for sentiment analysis, the app utilizes a custom dictionary-based NLP algorithm. The text is tokenized, stripped of stop-words, and compared against local datasets of positive and negative lexicons to calculate a net sentiment score.

### 2. Network Handling & Caching Strategy
The app uses a "Cache-First, Network-Update" approach. 
* **Online:** Fetches fresh data from the News API, displays it, and overwrites the local database cache.
* **Offline:** Detects the lack of connectivity and immediately queries the local database to populate the UI. A network listener runs in the background to trigger a fresh API call the moment connectivity is restored.

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* Android Studio / VS Code
* A valid API key from NewsAPI or GNews

### Installation

1. Clone the repository:
   ```bash
   git clone [https://github.com/eymaan12/Smart-News.git](https://github.com/eymaan12/Smart-News.git)
