{-# LANGUAGE OverloadedStrings #-}

module Wthr.Weather (Weather, getWeather, getMinimumTemperature, getMaximumTemperature, getDays) where

import Control.Applicative
import Control.Exception (throwIO)
import Data.Aeson
import Data.Time.Calendar
import Network.HTTP.Simple (parseRequest)
import Wthr.Error
import Wthr.Geo
import Wthr.Http

data Weather = Weather {getMinimumTemperature :: [Float], getMaximumTemperature :: [Float], getDays :: [Day]} deriving (Show)

instance FromJSON Weather where
  parseJSON (Object v) = do
    dailyVal <- v .: "daily"
    case dailyVal of
      Object daily ->
        Weather <$> daily .: "temperature_2m_min" <*> daily .: "temperature_2m_max" <*> daily .: "time"
      _ -> fail "failed to parse"
  parseJSON _ = empty

getWeather :: GeoLocation -> IO Weather
getWeather geo = do
  req <- parseRequest (weatherUrlBase geo)
  response <- getRequest req
  case (decode response :: Maybe Weather) of
    Nothing -> throwIO ParseWeatherResponse
    Just weather -> return weather
