# GonpaTour

GonpaTour is a mobile application built with Flutter that allows users to view, search, and scan for information about various Pilgrimage and organizations, displaying details that include audio, images, and text. This document provides an overview of the project's structure, setup instructions, key libraries used, and other technical details.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Project Structure](#project-structure)
4. [Libraries Used](#libraries-used)
5. [Installation and Setup](#installation-and-setup)
6. [Usage](#usage)
7. [Contributing](#contributing)
8. [License](#license)

---

## Project Overview

GonpaTour enables users to discover and explore various monasteries and organizations, presenting rich multimedia content such as text descriptions, audio recordings, and images. Users can search, view, or scan for specific information, making it a valuable tool for learning and exploration.

---

## Features

- **View Details**: Provides a comprehensive view of each monastery or organization, including descriptive text, images, and audio.
- **Search Functionality**: Allows users to search for specific monasteries or organizations.
- **Scan and Retrieve**: Enables scanning (QR/Barcode functionality) for quick access to specific details.
- **Multimedia Support**: Displays text, images, and plays audio for a richer experience.

---

## Project Structure

The project follows a modular folder structure to keep the code organized and maintainable.

```plaintext
lib/
├── config            # Configuration files (constants, themes, etc.)
├── l10n              # Localization files for multi-language support
├── models            # Data models for representing app data
├── states            # State management using Riverpod
└── UI                # User Interface components
    ├── screens       # Full-screen views for different app screens
    └── widgets       # Reusable UI widgets used across the app
```

---

## Libraries Used

The following major libraries are used in the project:

- **[Riverpod](https://pub.dev/packages/riverpod)**: Used for state management. Riverpod is selected for its flexibility, efficiency, and better support for asynchronous operations.
- **[Dio](https://pub.dev/packages/dio)**: A powerful HTTP client for making network requests to fetch data from APIs.
- **[GoRouter](https://pub.dev/packages/go_router)**: Provides routing management for navigation between screens, including support for deep linking.
- **[Sqflite](https://pub.dev/packages/sqflite)**: A database library for local data storage, used to store and retrieve scanned information or cached data.

---

## Installation and Setup

To set up the project locally, follow these steps:

1. **Clone the repository**:

   ```bash
   git clone https://github.com/OpenPecha/gompa-tour.git
   cd gompa-tour
   ```

2. **Install dependencies**:

   Ensure Flutter is installed on your system, then run:

   ```bash
   flutter pub get
   ```

3. **Set up configurations**:

   Add any necessary API keys or configuration files in the `lib/config` folder.

4. **Run the app**:

   Start the app on a connected device or emulator:

   ```bash
   flutter run
   ```

---

## Usage

Once the app is installed and running, users can:
Five Tabs
1. **Home**
2. **Map**
3. **Scan**
4. **Search**
5. **Settings**

### 1. Home
This section contains three main menus with detailed subcategories.

- **Pilgrimage**
  - **Popular Sites**
    - Top-rated pilgrimage sites
    - Historical significance

- **Organization**
  - **Monasteries**
    - List of registered monasteries
    - Affiliated organizations
  - **NGOs**
    - NGOs related to Tibetan culture
    - Contact information & donation options
  - **Community Centers**
    - Centers for Tibetan communities

- **Festival**
  - **Upcoming Festivals**
    - Dates and locations
    - Detailed event programs
  - **Local Celebrations**
    - Regional festival info
    - Cultural significance

---

### 2. Map
The map feature allows locating key spots with additional subcategories for enhanced navigation.

- **Locate Pilgrimage Sites**
  - Detailed map with pilgrimage site markers
  - Directions and distance from current location

- **Locate Organizations**
  - Map view of organizations and monasteries
  - Filters by type (Monasteries, NGOs, etc.)

---

### 3. Scan
The scan feature enables quick access to information through QR or barcodes.

- **QR Code**
  - Directs to detailed site information

- **Barcode**
  - Access to organization profiles
  - Quick access to festival events

---

### 4. Search
This feature helps users find specific monasteries or organizations by name.

- **Search by Name**
  - Autocomplete suggestions
  - Top results for relevant monasteries or organizations

- **Filter by Type**
  - Filter results by Monastery, NGO, Community Center, etc.
  - Location-based filtering (nearby or region-specific)

---

### 5. Setting
App settings allow for customizing the app experience.

- **Theme**
  - Light, Dark, and System themes
  - Custom color options

- **Language**
  - Select app language (e.g., Tibetan, English)

- **Notifications**
  - Enable/disable notifications

- **Help & Support**
  - FAQs
  - Contact support team

---

## Contributing

We welcome contributions to improve the GonpaTour app! If you want to contribute, please:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Create a pull request.

---

## License

This project is licensed under the MIT License.
