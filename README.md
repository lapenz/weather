# README

This app displays the weather info for a specific address using the OpenWeatherMap API.

The app is able to cache the requests based on address for a period of time that can be changed through an envar. 

Bootstrap used for styling and responsive designing of the app.

RestClient gem used for http request.

* Ruby version
2.7.1

* Configuration:

The Envars should be added to the 'config/local_env.yml' file:

```yaml
WEATHER_API_URL: 'https://api.openweathermap.org/data/2.5/weather'
WEATHER_API_KEY: 'e155ba888319d33e0b85dec3fa93ef64'
CACHE_EXPIRATION_LIMIT_IN_MINUTES: '30' # add 0 to disable cache
WEATHER_DEFAULT_UNIT: 'imperial'
 ```

* How to run the test suite:

run: `rspec`

* Services:

WeatherGetter: responsible for pulling weather data from the API. Fully covered by tests.

CacheManager: responsible for managing the cache, including the requests cache

* Controllers:

DashBoardsController: responsible for managing the requests and displaying the view on the main page

