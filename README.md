# Olly Olly Challenge

A Flutter app developed for the Olly Olly technical hiring challenge.

> **Criteria:**
> - **Correctness:** Does exactly what was requested
> - **Clarity:** Clean, readable, and well-organized code
> - **Best Practices:** Modern Flutter, SOLID, clean architecture, modularity

## Features

- **User Authentication:** Simple login (no backend)
- **Weather Display:** Shows current weather for the user's location (Celsius & Fahrenheit)
- **Responsive Design:** Works on web and mobile web
- **Modern Flutter:** Riverpod, Freezed, clean code, error handling, UX feedback
- **Environment Variables:** Secure API key management with `.env`
- **Assets:** Custom logo and icons

## Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd olly_olly_challenge
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**
   - Get a free API key from [OpenWeatherMap](https://openweathermap.org/api)
   - Create a `.env` file in the root directory:
     ```
     OPENWEATHER_API_KEY=your_actual_api_key_here
     WEATHER_API_BASE_URL=https://api.openweathermap.org/data/3.0/onecall
     WEATHER_API_EXCLUDE_PARAMS=alerts
     ```

4. **Run the app**
   ```bash
   flutter run -d chrome   # For web
   ```

## Project Structure

```
lib/
├── main.dart
├── app.dart
└── features/
    ├── auth/
    │   ├── login_screen.dart
    │   ├── auth_controller.dart
    │   ├── auth_state.dart
    │   └── auth_state.freezed.dart
    └── weather/
        ├── weather_screen.dart
        └── weather_service.dart
assets/
└── images/
    └── logo.svg
.env.example
```

## Technologies Used

- **Flutter**: UI framework
- **Riverpod**: State management
- **Freezed**: Immutable state classes
- **HTTP**: API requests
- **Geolocator**: Location services
- **flutter_dotenv**: Environment variables

## How it Works

1. **Login Screen:** User enters email and password (any non-empty values and valid e-mail formatting)
2. **Authentication:** Simple validation, no backend
3. **Weather Screen:** Fetches user's location and displays weather in Celsius and Fahrenheit
4. **API Integration:** Uses OpenWeatherMap API

## Environment Variables

- `OPENWEATHER_API_KEY`: Your OpenWeatherMap API key
- `WEATHER_API_BASE_URL`: Base URL for the weather API
- `WEATHER_API_EXCLUDE_PARAMS`: Parameters to exclude from API response

## Notes

- The app requires location permissions to work properly
- Add your actual OpenWeatherMap API key in the `.env` file
- The `.env` file is gitignored for security reasons
- All code follows clean architecture and best practices for clarity and maintainability

## License

MIT
