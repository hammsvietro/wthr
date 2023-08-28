module Wthr.PrettyPrint (prettyPrintWeather) where

import Data.Time
import Text.PrettyPrint.Boxes
import Wthr.Weather
import Prelude hiding ((<>))

formatTemperature :: TemperatureUnit -> Float -> String
formatTemperature Celsius t = show t ++ "°C"
formatTemperature Fahrenheit t = show t ++ "°F"

textL5 :: String -> Box
textL5 = alignHoriz left 5 . text

textC10 :: String -> Box
textC10 = alignHoriz center1 10 . text

enumerate :: [a] -> [(Int, a)]
enumerate = zip [0 ..]

formatForecastDate :: (Int, Day) -> String
formatForecastDate (0, _) = "Today"
formatForecastDate (1, _) = "Tomorrow"
formatForecastDate (_, day) = formatTime defaultTimeLocale "%d-%m-%Y" day

getForecastHeader :: WeatherForecast -> Box
getForecastHeader fc = moveUp 1 $ hsep 4 center1 boxes
  where
    boxes = textL5 "" : (textC10 . formatForecastDate <$> enumerate (getDays fc))

getForecastRow :: WeatherForecast -> (WeatherForecast -> [Float]) -> [Box]
getForecastRow fc fn = textC10 . formatTemperature Celsius <$> fn fc

prettyPrintWeather :: WeatherForecast -> IO ()
prettyPrintWeather weather = do
  let headerBox = getForecastHeader weather
  let maxBox = hsep 4 center1 $ textL5 "Max:" : getForecastRow weather getMaximumTemperatures
  let minBox = hsep 4 center1 $ textL5 "Min:" : getForecastRow weather getMinimumTemperatures
  let box = headerBox // maxBox // minBox
  printBox box
