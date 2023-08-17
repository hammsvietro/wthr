{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Wthr.Geo (GeoLocation, getWeatherUrl) where

import Control.Applicative
import Data.Aeson
import Network.HTTP.Simple (Request, parseRequest)
import Text.Printf (printf)

type Latitude = Float
type Longitude = Float
type Timezone = String
data GeoLocation = GeoLocation {latitude :: Latitude, longitude :: Longitude, timezone :: Timezone} deriving (Show)

instance FromJSON GeoLocation where
  parseJSON (Object v) = GeoLocation <$> v .: "lat" <*> v .: "lon" <*> v .: "timezone"
  parseJSON _ = empty

weatherUrlBase :: GeoLocation -> String
weatherUrlBase GeoLocation{..} = printf "https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&timezone=%s&current_weather=true&daily=temperature_2m_max,temperature_2m_min" (show latitude) (show longitude) timezone

getWeatherUrl :: GeoLocation -> IO Request
getWeatherUrl = parseRequest . weatherUrlBase
