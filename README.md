# Weather App

This is a weather app developed using Swift and Xcode in the Spring of 2022. It utilizes the following Cocoapods libraries: KingFisher and SwiftyJSON, along with Apple's UIKit, MapKit, and CoreLocation frameworks. It also makes use of the OpenWeatherMap API.

## Getting Started

To get started, clone this repository and open the `WeatherApp.xcodeproj` file in Xcode. Make sure to run `pod install` to install the required Cocoapods dependencies before running the app.

### Prerequisites

- Xcode 11 or later
- Cocoapods

### Installing

1. Clone this repository to your local machine.
2. Run `pod install` in the terminal to install the required Cocoapods dependencies.
3. Open `WeatherApp.xcworkspace` in Xcode.
4. Build and run the app.

## Features

- The app displays the current weather conditions for the user's current location or a location of their choice.
- Users can search for the weather in any location by entering the city and country or city and state.
- The app displays the temperature, humidity, wind speed, and other relevant weather information.
- The app also displays an hourly and daily forecast for the selected location.
- Users can view the location on a map with the weather conditions displayed as an overlay.

## Dependencies

- [KingFisher](https://github.com/onevcat/Kingfisher) - A powerful and lightweight library for downloading and caching images from the web.
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) - A library for working with JSON data in Swift.
- UIKit, MapKit, and CoreLocation frameworks from Apple.
- [OpenWeatherMap API](https://openweathermap.org/api) - A weather data API that provides current weather data and forecasts for locations around the world.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
