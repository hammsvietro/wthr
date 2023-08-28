module Main (main) where

import Control.Exception (try)
import System.Exit (ExitCode (ExitFailure), exitWith)
import Wthr.Error
import Wthr.Geo
import Wthr.PrettyPrint
import Wthr.Weather

run :: IO ()
run = getGeolocation >>= getWeather >>= prettyPrintWeather

main :: IO ()
main = do
  result <- try run :: IO (Either WthrException ())
  case result of
    Right _ -> pure ()
    Left e -> print e >> exitWith (ExitFailure (-1))
