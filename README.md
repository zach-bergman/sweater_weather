# Sweater Weather

## Overview

**Sweater Weather** is a Rails API application designed to provide weather information and related services. This project demonstrates how to aggregate data from multiple external APIs and exposes several endpoints requiring authentication and providing CRUD functionality.
## Learning Goals

The Sweater Weather project aims to achieve the following learning goals:

1. **API Integration**: Aggregate and utilize data from multiple external APIs, such as MapQuest and WeatherAPI, to deliver comprehensive weather and location-based services.

2. **API Authentication**: Implement authentication tokens to secure API access, ensuring only authorized users can access protected endpoints.

3. **CRUD Functionality**: Expose an API to create a new user.

4. **Completion Criteria**: Determine project completion criteria based on the needs of other developers, focusing on usability, functionality, and code quality.

5. **Testing and Mocking**: Thoroughly test both API consumption and exposure using tools like VCR and WebMock to mock external API requests and ensure reliability.

## Cloning and Setting Up the Application

### Prerequisites

Before setting up the application, ensure you have the following installed:

- Ruby
- Rails
- PostgreSQL

### Cloning the Repository

Clone the repository and navigate into the project directory:

```bash
git clone https://github.com/zach-bergman/sweater_weather.git
cd sweater_weather
```

### Setting Up the Application

1. **Install Dependencies**: Run the following command to install the required gems:

   ```bash
   bundle install
   ```

2. **Set Up the Database**: Create and migrate the database:

   ```bash
   rails db:create
   rails db:migrate
   ```

3. **Configure Environment Variables**: Create a `.env` file in the root directory to store your API keys. You can use the `.env.example` file as a template. Replace placeholders with your actual API keys:

   ```plaintext
   MAPQUEST_API_KEY=your_mapquest_api_key
   OPENWEATHER_API_KEY=your_openweather_api_key
   ```

4. **Run the Server**: Start the Rails server:

   ```bash
   rails server
   ```

   The application will be accessible at `http://localhost:3000`.

### Obtaining API Keys

To use this application, you need API keys from the following services:

- **MapQuest API**: Sign up at the [MapQuest Developer Portal](https://developer.mapquest.com/) to obtain your API key.
- **OpenWeather API**: Sign up at the [OpenWeather website](https://openweathermap.org/api) to obtain your API key.

### Running Tests

Run the test suite to verify application functionality:

```bash
bundle exec rspec
```

The test suite uses **VCR** and **WebMock** to mock external API requests, ensuring tests are reliable and do not depend on external services being available.

## API Endpoints

### 1. Weather Forecast

- **Endpoint**: `/api/v1/forecast`
- **Method**: `GET`
- **Parameters**: 
  - `location` (required): The location for which to retrieve the weather forecast, e.g., `Denver,CO`.

#### Example Request

```http
GET /api/v1/forecast?location=Denver,CO
```

#### Example Response

```json
{
  "data": {
    "id": null,
    "type": "forecast",
    "attributes": {
      "current_weather": {
        "last_updated": "2024-08-06 14:45",
        "temperature": 65.3,
        "feels_like": 90.4,
        "humidity": 17,
        "uvi": 8.0,
        "visibility": 6.0,
        "condition": "Sunny",
        "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png"
      },
      "daily_weather": [
        {
          "date": "2024-08-06",
          "sunrise": "06:04 AM",
          "sunset": "08:07 PM",
          "max_temp": 95.8,
          "min_temp": 69.8,
          "condition": "Patchy rain nearby",
          "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
        }
      ],
      "hourly_weather": [
        {
          "time": "2024-08-06 00:00",
          "temperature": 70.6,
          "conditions": "Partly Cloudy ",
          "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png"
        }
      ]
    }
  }
}
```

### 2. Road Trip Weather

- **Endpoint**: `/api/v1/road_trip`
- **Method**: `POST`
- **Parameters**:
  - `origin` (required): The starting location, e.g., `New York,NY`.
  - `destination` (required): The destination location, e.g., `Los Angeles,CA`.
  - `api_key` (required): The user’s API key for authentication.

#### Example Request

```http
POST /api/v1/road_trip
Content-Type: application/json

{
  "origin": "New York,NY",
  "destination": "Los Angeles,CA",
  "api_key": "user_api_key"
}
```

#### Example Response

```json
{
  "data": {
    "id": null,
    "type": "roadtrip",
    "attributes": {
      "start_city": "New York, NY",
      "end_city": "Los Angeles, CA",
      "travel_time": "40:03:17",
      "weather_at_eta": {
        "datetime": "2024-08-08",
        "temperature": 79.1,
        "condition": "Sunny"
      }
    }
  }
}
```

### 3. User Management (CRUD)

#### Create a User

- **Endpoint**: `/api/v1/users`
- **Method**: `POST`
- **Parameters**:
  - `email` (required): The user's email address.
  - `password` (required): The user's password.
  - `password_confirmation` (required): Confirmation of the user's password.

#### Example Request

```http
POST /api/v1/users
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

#### Example Response

```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "email": "test@example.com",
      "api_key": "generated_api_key"
    }
  }
}
```

### 4. User Login

- **Endpoint**: `/api/v1/sessions`
- **Method**: `POST`
- **Parameters**:
  - `email` (required): The user's email address.
  - `password` (required): The user's password.

#### Example Request

```http
POST /api/v1/sessions
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "password123"
}
```

#### Example Response

```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "email": "test@example.com",
      "api_key": "existing_api_key"
    }
  }
}
```
