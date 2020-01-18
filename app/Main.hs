{-# LANGUAGE OverloadedStrings #-}
module Main where

import Lib
import Network.Wai
import Network.Wai.Handler.Warp (run)
import Network.HTTP.Types (status200)

main :: IO ()
main = run 3000 $ \_req send ->
  send $ responseBuilder
    status200
    [("Content-Type", "text/plain; charset=utc-8")]
    "Hello from WAI"
