{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Data.Aeson
import Data.ByteString.Lazy.Internal as Lazy (ByteString)
import Data.Functor
import Network.HTTP.Simple
import Wthr.Geo
import Wthr.Weather

getGeolocationUrl :: Request
getGeolocationUrl = "http://ip-api.com/json/"

getRequest :: Request -> IO Lazy.ByteString
getRequest request = httpLbs request <&> getResponseBody

main :: IO ()
main = do
  geoData <- getRequest getGeolocationUrl
  case (decode geoData :: Maybe GeoLocation) of
    Nothing -> return ()
    Just geo -> do
      res <- getWeatherUrl geo >>= getRequest
      print (decode res :: Maybe Weather)
      return ()
