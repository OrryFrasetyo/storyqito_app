# 📱 Storyqito App

<div align="center">
  <img src="assets/icon/storyqito-logo.png" alt="Storyqito Logo" width="120" height="120">
  <h3>Flutter Story Sharing App with Location & Maps Integration</h3>
</div>

## 🌟 About Project

**Storyqito** is a mobile application that allows users to share stories with images and location information. The application was developed using Flutter with a clean and scalable architecture, supporting multi-platform (Android, iOS, Web) and multi-language (Indonesian & English).

[![Flutter Version](https://img.shields.io/badge/flutter-v3.32.8-blue?logo=flutter&logoColor=white)](https://github.com/flutter/flutter/blob/main/CHANGELOG.md#3320)

## ✨ Features

### 🔐 Authentication

- Login & Register with email validation
- Session management with SharedPreferences
- Auto-redirect orde by login status

### 📖 Story Management

- See a list of stories from all users
- Detail story with location information
- Pull-to-refresh to latest data update
- Infinite scrolling for optimal performance

### 📸 Upload Story

- Take a photo using the camera or gallery
- Preview images before uploading
- Add story description
- Integration location GPS (premium feature)
- Support for websites with special camera widgets

### 🗺️ Maps Integration

- Google Maps integration
- Show the story location on the map
- Location picker for uploading stories
- Fullscreen map view

### ⚙️ Settings & Personalization

- Dark/Light theme toggle
- Multi-language support (ID/EN)
- User preferences management

### 🌐 Multi-Platform Support

- Android & iOS native
- Progressive Web App (PWA)
- Responsive design for tablets

## 🛠️ Tech Stack

### Framework & Language

- **Flutter** ^3.7.2 - Cross-platform development
- **Dart** - Programming language

### State Management

- **Provider** ^6.1.4 - State management solution
- **Equatable** ^2.0.7 - Value equality

### Network & API

- **HTTP** ^1.3.0 - REST API communication
- **JSON Annotation** ^4.9.0 - JSON serialization

### Navigation & Routing

- **Go Router** ^15.1.2 - Declarative routing
- Custom page transitions

### UI/UX Components

- **Lottie** ^3.3.1 - Animations
- **Material Design 3** - Modern UI components
- **Custom Fonts** - Quicksand font family
- **Dropdown Button 2** ^2.3.9 - Enhanced dropdowns

### Camera & Media

- **Image Picker** ^1.1.2 - Gallery & camera access
- **Camera** ^0.11.1 - Camera functionality

### Maps & Location

- **Google Maps Flutter** ^2.12.1 - Maps integration
- **Geolocator** ^14.0.0 - GPS location services

### Localization

- **Flutter Localizations** - Multi-language support
- **Intl** ^0.20.2 - Internationalization

### Development Tools

- **Build Runner** ^2.4.15 - Code generation
- **Freezed** ^3.0.6 - Immutable classes
- **Flutter Lints** ^5.0.0 - Code quality

## 🏗️ Architecture Project

lib/
├── core/ # Core functionality
│ ├── constant/ # App constants
│ ├── data/ # Data layer (models, network, repository)
│ ├── localization/ # Multi-language support
│ ├── provider/ # State management providers
│ ├── routes/ # App routing configuration
│ ├── style/ # Themes and styling
│ ├── utils/ # Utility functions
│ └── variant/ # Build configurations
├── features/ # Feature modules
│ ├── auth/ # Authentication screens
│ ├── home/ # Home & story list
│ ├── detail/ # Story detail view
│ ├── upload/ # Story upload functionality
│ ├── map/ # Maps integration
│ ├── setting/ # App settings
│ └── widget/ # Shared widgets
├── main.dart # App entry point
└── my_app.dart # App configuration

## 🛠️ Getting Started

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### 🚀 Develop Step by Step

To develop this project, please read [here](./doc/development.md)

## 📚 API Documentation

This application use several API's:

- Dicoding Story API:
  [https://story-api.dicoding.dev/v1/](https://story-api.dicoding.dev/v1/)
- Geocode API
  [https://geocode.maps.co/](https://geocode.maps.co/)

## 📸 Screenshots

<details>
<summary>📱 Mobile Platform | Light Mode </summary>
<p float="left">
  <img src="doc/result/light/mobile/login-light.jpeg"
    width="250" alt="Login Screen"
  />
  <img src="doc/result/light/mobile/register-light.jpeg"
    width="250" alt="Register Screen"
  />
  <img src="doc/result/light/mobile/home-light.jpeg"
    width="250" alt="Home Screen"
  />
</p>
<p float="left">
  <img src="doc/result/light/mobile/map-light.jpeg"
    width="250" alt="Map Story Screen"
  />  
  <img src="doc/result/light/mobile/camera-light.jpeg"
    width="250" alt="Upload Story Screen"
    />
  <img src="doc/result/light/mobile/upload-story-light.jpeg"
    width="250" alt="Upload Story Screen Filled"
    />
</p>
<p>
<img src="doc/result/light/mobile/detail-story-light.jpeg"
    width="250" alt="Detail Story Screen"
    />
  <img src="doc/result/light/mobile/setting-light.jpeg"
    width="250" alt="Settings Screen"
  />
  <img src="doc/result/light/mobile/localization-light.jpeg"
    width="250" alt="Localization Dialog"
  />
</p>
</details>

<details>
<summary>📱 Mobile Platform | Dark Mode </summary>
<p float="left">
  <img src="doc/result/dark/mobile/login-dark.jpeg"
    width="250" alt="Login Screen (Dark)"
  />
  <img src="doc/result/dark/mobile/register-dark.jpeg"
    width="250" alt="Register Screen (Dark)"
  />
  <img src="doc/result/dark/mobile/home-story-dark.jpeg"
    width="250" alt="Home Screen (Dark)"
  />
</p>
<p float="left">
  <img src="doc/result/dark/mobile/map-dark.jpeg"
    width="250" alt="Map Story Screen (Dark)"
  />  
  <img src="doc/result/dark/mobile/camera-dark.jpeg"
    width="250" alt="Upload Story Screen (Dark)"
    />
  <img src="doc/result/dark/mobile/upload-story-dark.jpeg"
    width="250" alt="Upload Story Screen Filled (Dark)"
    />
</p>
<p>
<img src="doc/result/dark/mobile/detail-story-dark.jpeg"
    width="250" alt="Detail Story Screen (Dark)"
    />
  <img src="doc/result/dark/mobile/setting-dark.jpeg"
    width="250" alt="Settings Screen (Dark)"
  />
  <img src="doc/result/dark/mobile/localization-dark.jpeg"
    width="250" alt="Localization Dialog (Dark)"
  />
</p>
</details>

<details>
<summary>🖥️ Desktop Platform | Light Mode</summary>
<p>
  <img src="doc/result/light/desktop/login.png"
    width="400" alt="Login Screen"
  />
  <img src="doc/result/light/desktop/register.png"
    width="400" alt="Register Screen"
  />
</p>
<p>
  <img src="doc/result/light/desktop/home.png"
    width="400" alt="Home Screen"
  />
  <img src="doc/result/light/desktop/detail-story.png"
    width="400" alt="Detail Story Screen"
  />
</p>
<p>
  <img src="doc/result/light/desktop/map.png"
    width="400" alt="Map Screen"
  />
  <img src="doc/result/light/desktop/setting.png"
    width="400" alt="Settings Screen"
  />
</p>
<p>
  <img src="doc/result/light/desktop/upload-story.png"
    width="400" alt="Upload Story Screen"
  />
  <img src="doc/result/light/desktop/upload-story-filled.png"
    width="400" alt="Upload Story Screen Filled"
  />
</p>
<p>
  <img src="doc/result/light/desktop/localization.png"
    width="400" alt="Localization Dialog"
  />
</p>
</details>

<details>
<summary>🖥️ Desktop Platform | Dark Mode</summary>
<p>
  <img src="doc/result/dark/desktop/login-dark.png"
    width="400" alt="Login Screen (Dark)"
  />
  <img src="doc/result/dark/desktop/register-dark.png"
    width="400" alt="Register Screen (Dark)"
  />
</p>
<p>
  <img src="doc/result/dark/desktop/home-dark.png"
    width="400" alt="Home Screen (Dark)"
  />
  <img src="doc/result/dark/desktop/detail-story-dark.png"
    width="400" alt="Detail Story Screen (Dark)"
  />
</p>
<p>
  <img src="doc/result/dark/desktop/map-dark.png"
    width="400" alt="Map Screen (Dark)"
  />
  <img src="doc/result/dark/desktop/setting-dark.png"
    width="400" alt="Settings Screen (Dark)"
  />
</p>
<p>
  <img src="doc/result/dark/desktop/upload-story-dark.png"
    width="400" alt="Upload Story Screen (Dark)"
  />
  <img src="doc/result/dark/desktop/upload-story-filled-dark.png"
    width="400" alt="Upload Story Screen Filled (Dark)"
  />
</p>
<p>
  <img src="doc/result/dark/desktop/localization-dark.png"
    width="400" alt="Localization Dialog (Dark)"
  />
</p>
</details>

## 📽️ Link Demo

[https://drive.google.com/file/d/1y94_NtTufYiHhVvOZS-G1V7kMlcH3Fhc/view?usp=sharing](https://drive.google.com/file/d/1y94_NtTufYiHhVvOZS-G1V7kMlcH3Fhc/view?usp=sharing)
## License

[Apache Version 2.0](LICENSE)

```text
Copyright 2025 Orry Frasetyo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0


```
