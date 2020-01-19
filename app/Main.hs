{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Network.Wai
import Network.Wai.Handler.Warp (run)
import Network.HTTP.Types (status200, status404)
import Data.Text as T
import Data.Text.Encoding

main :: IO ()
main = run 3000 $ \req send ->
  case pathInfo req of
    [] -> send $ responseBuilder
            status200
            [("Content-Type", "text/plain; charset=utc-8")]
            "Hello from WAI"
    ["hello", name] -> send $ responseBuilder
            status200
            []
            (encodeUtf8Builder (T.concat [T.pack "Hello, ", name]))
    _ ->  send $ responseBuilder status404 []
            "These are not the droid you are looking for"
