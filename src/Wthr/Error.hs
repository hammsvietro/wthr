module Wthr.Error (WthrException (..)) where

import Control.Exception (Exception)
import Data.Typeable

data WthrException = ParseGeoLocationResponse | ParseWeatherForecastResponse deriving (Eq, Typeable)

instance Exception WthrException

instance Show WthrException where
  show ParseGeoLocationResponse = "Error: Could not parse the response of the geo location request"
  show ParseWeatherForecastResponse = "Error: Could not parse the response of the weather forecast request"
