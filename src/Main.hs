{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Data.Aeson
import Network.HTTP.Simple
import Wthr.Geo
import Wthr.Http
import Wthr.Weather

getGeolocationUrl :: Request
getGeolocationUrl = "http://ip-api.com/json/"

printTodaysWeather :: Weather -> IO ()
printTodaysWeather weather = do
  putStrLn "Today's weather:"
  let minimumTemperature' = show $ head $ getMinimumTemperature weather
  let maxmimumTemperature' = show $ head $ getMaximumTemperature weather
  putStrLn $ "Min: " ++ minimumTemperature'
  putStrLn $ "Max: " ++ maxmimumTemperature'

main :: IO ()
main = do
  geoData <- getRequest getGeolocationUrl
  case (decode geoData :: Maybe GeoLocation) of
    Nothing -> return ()
    Just geo -> getWeather geo >>= printTodaysWeather
