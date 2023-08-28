{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Wthr.Weather (WeatherForecast (..), getWeather, TemperatureUnit (..)) where

import Control.Applicative
import Control.Exception (throwIO)
import Data.Aeson
import Data.Time.Calendar
import Network.HTTP.Simple (parseRequest)
import Text.Printf (printf)
import Wthr.Error
import Wthr.Geo
import Wthr.Http

data TemperatureUnit = Celsius | Fahrenheit

data WeatherForecast = Weather {getMinimumTemperatures :: [Float], getMaximumTemperatures :: [Float], getDays :: [Day]} deriving (Show)

instance FromJSON WeatherForecast where
  parseJSON (Object v) = do
    dailyVal <- v .: "daily"
    case dailyVal of
      Object daily ->
        Weather <$> daily .: "temperature_2m_min" <*> daily .: "temperature_2m_max" <*> daily .: "time"
      _ -> fail "failed to parse"
  parseJSON _ = empty

getWeather :: GeoLocation -> IO WeatherForecast
getWeather geo = do
  req <- parseRequest (weatherUrlBase geo)
  response <- getRequest req
  case (decode response :: Maybe WeatherForecast) of
    Nothing -> throwIO ParseWeatherForecastResponse
    Just weather -> return weather

weatherUrlBase :: GeoLocation -> String
weatherUrlBase GeoLocation {..} = printf "https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&timezone=%s&current_weather=true&daily=temperature_2m_max,temperature_2m_min" (show getLatitude) (show getLongitude) getTimezone
