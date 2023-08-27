module Wthr.Http (getRequest) where

import Data.ByteString.Lazy.Internal as Lazy (ByteString)
import Data.Functor
import Network.HTTP.Simple

getRequest :: Request -> IO Lazy.ByteString
getRequest request = httpLbs request <&> getResponseBody
