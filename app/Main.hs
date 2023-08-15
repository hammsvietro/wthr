{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Exception (handle)
import Data.Aeson
import Data.ByteString (ByteString)
import qualified Data.ByteString as C8 (pack, unpack)
import qualified Data.ByteString.Lazy.Internal as Lazy (ByteString, toStrict)
import Data.Char (chr)
import Data.Functor
import Network.HTTP.Simple
import Wthr.Geo

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
      res <-
        getWeatherUrl geo >>= getRequest
      print res
      return ()
