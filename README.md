# SpotCheck - Location Tracking App

![SpotCheck Logo](https://i.postimg.cc/76D9m007/brand.png)

## Introduction

SpotCheck is a powerful location tracking app designed to help users automate their phone's settings based on their current location. With SpotCheck, users can easily specify locations and define actions to be performed when they enter or exit those locations. The app sends notifications to users when the specified actions are triggered, providing a seamless and personalized mobile experience.

## Key Features

- **Location-based Actions:** Users can set up custom actions to be performed when they enter or exit a specific location. This allows for automatic adjustments to the phone's settings or triggering certain events.

- **Flexible Radius:** SpotCheck allows users to define the radius for each location, with a maximum limit of 1000 meters. This ensures precise control over location-based actions based on proximity.

- **Real-Time Notifications:** Users receive notifications instantly when the specified actions are triggered. This keeps them informed about the changes made or events occurring based on their location.

- **Firebase Firestore:** A cloud-hosted NoSQL database offered by Firebase that enables real-time data synchronization and storage for SpotCheck. It stores user-defined locations, associated actions, and other app data securely.
## Dependencies

SpotCheck utilizes the following dependencies to provide its functionality:

- **Flutter: 3.10.2:** Flutter is an open-source UI toolkit developed by Google for building natively compiled applications for mobile, web, and desktop from a single codebase. SpotCheck leverages Flutter's cross-platform capabilities to deliver a consistent experience across different devices.

- **Dart: 3.0.2:** Dart is the programming language used by Flutter to build high-performance, robust applications. SpotCheck utilizes Dart for writing the business logic and handling the app's functionality.

- **Google Maps Places API:** SpotCheck integrates with the Google Maps Places API to enable location search and selection. This API provides access to a vast database of places and allows users to specify their desired locations accurately.

- **Google Maps Geolocation API:** The Google Maps Geolocation API is utilized by SpotCheck to retrieve the user's current location. This API provides precise geolocation data, which is used to trigger the specified actions when the user enters or exits a location.

## Getting Started

To get started with SpotCheck, follow these steps:

1. Clone the SpotCheck repository from GitHub:
```bash
git clone https://github.com/alinaqi2000/spot_check
```

2. Install Flutter and set up your development environment. You can find detailed instructions in the Flutter documentation: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

3. Open the SpotCheck project in your preferred IDE or text editor.

4. Install the required dependencies by running the following command in the project directory:
```bash
flutter pub get
```

5. Build and run the


## Demos

The following GIFs showcase the functionality and user experience of SpotCheck:

1. **Home Screen:**

![Home Screen](https://i.postimg.cc/7LrcgvWB/sc-home.gif)

2. **Select Location:**

![Select Location](https://i.postimg.cc/cLL72F8s/sc-select-location.gif)

3. **Select Actions:**

![Select Actions](https://i.postimg.cc/DfxtRMSZ/sc-select-action.gif)

4. **Real-Time Notifications:**

![Real-Time Notifications](https://i.postimg.cc/N08nDJhQ/sc-notifications.gif)

## License
SpotCheck is released under the MIT License.

