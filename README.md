# cloudy

_Your weather companion, come rain or shine._

Are you a developer? Go ahead to the [Development Information](#development-information) section.


## Welcome to Cloudy: Your Weather Companion!

Thank you for choosing Cloudy to keep you informed about the weather conditions in your area. Whether it's sunny skies or stormy clouds, Cloudy has got you covered. Below you'll find all the information you need to make the most out of your weather app experience.

### Screnshots

| home | search | forecast |
| --- | --- | --- |
| ![home](/screenshots/image-0.png) | ![search](/screenshots/image-1.png) | ![forecast](/screenshots/image-2.png)

| dark home | dark search | dark forecast |
| --- | --- | --- |
| ![dark home](/screenshots/image-3.png) | ![dark search](/screenshots/image-4.png) | ![dark forecast](/screenshots/image-5.png)


## Why Choose Cloudy?

Reliable Accuracy: Cloudy utilizes advanced weather data to provide reliable and accurate forecasts. Say goodbye to unexpected weather surprises!

Sleek Design: With its modern design and intuitive features, Cloudy offers a seamless user experience that keeps you coming back for more.

Your Weather Companion: At Cloudy, we understand the importance of having a reliable weather companion by your side. Come rain or shine, Cloudy is here to help you weather the storm.

## Current Features:

### Real-time Weather Updates
Stay up-to-date with the latest weather conditions in your location. Cloudy provides accurate and timely updates so you can plan your day accordingly.

### Detailed Forecasts
Get detailed forecasts including current, maximum and minimum temperatures for that day. Cloudy provides comprehensive information to help you make informed decisions about your day.

### Automatic dark mode

Cloudy seamlessly adjusts to your system's theme style, offering a comfortable viewing experience day or night. Say goodbye to eye strain with our automatic dark mode feature.

### Offline Cache
Cloudy saves previous weather information to be accessed when offline, ensuring you stay informed even when internet connectivity is limited.

### Beautiful Visuals
Enjoy stunning visuals that reflect the current weather conditions. From clear blue skies to dramatic thunderstorms, Cloudy brings the weather to life with captivating imagery.

### Intuitive Interface
Navigate Cloudy with ease thanks to its user-friendly interface. Whether you're a weather enthusiast or just looking for a quick update, Cloudy makes it simple to find the information you need.

## Roadmap - Future Updates

Customizable Locations: Add multiple locations to keep track of the weather in your favorite destinations. Whether you're at home, work, or planning a trip, Cloudy ensures you're always prepared.

Personalized Alerts: Receive personalized alerts for severe weather warnings, ensuring your safety is always a top priority.

## Feedback and Support:

We're constantly striving to improve Cloudy and would love to hear your feedback. Have a suggestion or experiencing an issue? Don't hesitate to reach out to our support team at cloudy@kaio.dev.

Thank you for choosing Cloudy as your weather companion. Here's to clearer skies and brighter days ahead!

## Development Information

### Build Configurations

Cloud is build with Flutter. In order to run the app, you need to have Flutter installed on your machine. Don't have Flutter installed, follow the instructions [here](https://flutter.dev/docs/get-started/install).

After cloning this repo and running `flutter pub get` to install the dependencies, you need to set up the following build configurations to run the app successfully:

1. OpenWeatherMap API Key
- You need an OpenWeatherMap API key to access the weather data. You can sign up to get one [here](https://home.openweathermap.org/users/sign_up).

2. `dev.env` file
- Create a `dev.env` file in the root directory of the project.
- Add the following environment variables to the `dev.env` file:
```
API_KEY=your_openweathermap_api_key
BASE_URL=https://api.openweathermap.org/data/2.5
```

3. Run the app
- You can either use the pre-configured launch configurations in VS Code or Android Studio to run the app or run the following command in the terminal:
```
flutter run --dart-define=API_KEY=your_openweathermap_api_key \
--dart-define=BASE_URL=https://api.openweathermap.org/data/2.5
```

## Troubleshooting

- WI-FI: in some cases, toggle your WI-FI off and on again to refresh the connection might help when the app is not loading data.