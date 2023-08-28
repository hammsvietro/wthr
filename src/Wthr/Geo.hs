{-# LANGUAGE OverloadedStrings #-}

module Wthr.Geo (GeoLocation (..), getGeolocation) where

import Control.Applicative
import Control.Exception (throwIO)
import Data.Aeson
import Network.HTTP.Client.Conduit (Request)
import Wthr.Error (WthrException (ParseGeoLocationResponse))
import Wthr.Http (getRequest)

type Latitude = Float

type Longitude = Float

type Timezone = String

data GeoLocation = GeoLocation
  { getLatitude :: Latitude,
    getLongitude :: Longitude,
    getTimezone :: Timezone
  }
  deriving (Show)

instance FromJSON GeoLocation where
  parseJSON (Object v) = GeoLocation <$> v .: "lat" <*> v .: "lon" <*> v .: "timezone"
  parseJSON _ = empty

getGeolocationUrl :: Request
getGeolocationUrl = "http://ip-api.com/json/"

getGeolocation :: IO GeoLocation
getGeolocation = do
  geoData <- getRequest getGeolocationUrl
  case (decode geoData :: Maybe GeoLocation) of
    Nothing -> throwIO ParseGeoLocationResponse
    Just geo -> return geo
