{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import Lib
import Network.Wai
import Network.Wai.Handler.Warp (run)
import Network.HTTP.Types (status200, status404, status405)
import Data.Text as T
import Data.Text.Encoding
import Data.Aeson (ToJSON, toEncoding, (.=), object, encode, genericToEncoding, defaultOptions)
import GHC.Generics
import Data.ByteString.Builder (lazyByteString)
import Database.PostgreSQL.Simple

data Job = Job { id :: String, status :: String }
  deriving (Generic, Show)

instance ToJSON Job where
  toEncoding = genericToEncoding defaultOptions

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
            _     -> send badRequestMethod
    ["hello", name] -> send $ responseBuilder
            status200
            []
            (encodeUtf8Builder (T.concat [T.pack "Hello, ", name]))
    ["job"] -> send $ responseBuilder
                status200
                []
                (lazyByteString (encode (Job "uuid" "pending")))
    _ ->  send $ responseBuilder status404 []
            "These are not the droid you are looking for"


testPostgres :: IO ()
testPostgres = do
  i <- testPostgresQuery
  print i

testPostgresQuery :: IO Int
testPostgresQuery = do
  conn <- connectPostgreSQL "host='localhost' dbname='postgres'"
  [Only i] <- query_ conn "select 2 + 2"
  return i