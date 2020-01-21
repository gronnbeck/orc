{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Network.Wai
import Network.Wai.Handler.Warp (run)
import Network.HTTP.Types (status200, status404, status405)
import Data.Text as T
import Data.Text.Encoding

badRequestMethod :: Response
badRequestMethod = responseBuilder status405 [] "Bad request method"

main :: IO ()
main = run 3000 $ \req send ->
  case pathInfo req of
    [] -> case requestMethod req of
      "GET" -> send $ responseBuilder
                status200
                [("Content-Type", "text/plain; charset=utc-8")]
                "Hello from WAI"
       _    -> pure badRequestMethod
    ["hello", name] -> send $ responseBuilder
            status200
            []
            (encodeUtf8Builder (T.concat [T.pack "Hello, ", name]))
    _ ->  send $ responseBuilder status404 []
            "These are not the droid you are looking for"
