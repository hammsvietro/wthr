module Main (main) where

import Data.Aeson
import Wthr.Geo
import Wthr.Http
import Wthr.PrettyPrint
import Wthr.Weather

main :: IO ()
main = do
  geoData <- getRequest getGeolocationUrl
  case (decode geoData :: Maybe GeoLocation) of
    Nothing -> return ()
    Just geo -> getWeather geo >>= prettyPrintWeather
