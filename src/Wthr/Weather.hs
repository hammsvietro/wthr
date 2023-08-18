{-# LANGUAGE OverloadedStrings #-}

module Wthr.Weather (Weather) where

import Control.Applicative
import Data.Aeson
import Data.Time.Calendar

data Weather = Weather {getMinimumTemperature :: [Float], getMaximumTemperature :: [Float], days :: [Day]} deriving (Show)

instance FromJSON Weather where
  parseJSON (Object v) = do
    dailyVal <- v .: "daily"
    case dailyVal of
      Object daily ->
        Weather <$> daily .: "temperature_2m_min" <*> daily .: "temperature_2m_min" <*> daily .: "time"
      _ -> fail "failed to parse"
  parseJSON _ = empty
