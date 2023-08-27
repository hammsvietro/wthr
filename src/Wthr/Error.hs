module Wthr.Error (WthrException (..)) where

import Control.Exception (Exception)
import Data.Typeable

data WthrException = ParseGeoLocationResponse | ParseWeatherResponse deriving (Eq, Show, Typeable)

instance Exception WthrException
