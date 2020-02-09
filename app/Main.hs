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
import Data.UUID
import qualified Data.UUID.V4 as UUIDV4
import GHC.Generics
import Data.ByteString.Builder (lazyByteString)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.Migration
import qualified Data.ByteString as BS8
import Database.PostgreSQL.Simple.FromField
import Database.PostgreSQL.Simple.FromRow

data Job = Job { id :: UUID, status :: String }
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
    ["job"] -> do
      id <- UUIDV4.nextRandom
      send $ responseBuilder
                status200
                []
                (lazyByteString (encode (Job id "pending")))
    ["job-description"] -> do
      jobDescs <- getJobDescriptions 
      let
        (Only jobDesc) = Prelude.head jobDescs
        in
        send $ responseBuilder
          status200
          []
          (lazyByteString (encode (Job jobDesc "pending")))
    _ ->  send $ responseBuilder status404 []
            "These are not the droid you are looking for"

connStr = "host='localhost' dbname='ork'"

migrate :: IO ()
migrate = do
    let url = connStr
    let dir = "./migrations"
    con <- connectPostgreSQL url
    withTransaction con $ runMigration $
      MigrationContext (MigrationCommands [MigrationInitialization, MigrationDirectory dir]) True con
    print "Migration done"

testPostgres :: IO ()
testPostgres = do
  i <- testPostgresQuery
  print i

testPostgresQuery :: IO Int
testPostgresQuery = do
  conn <- connectPostgreSQL connStr
  [Only i] <- query_ conn "select 2 + 2"
  return i

getJobDescriptions :: IO [Only UUID]
getJobDescriptions = do
  conn <- connectPostgreSQL connStr
  a <- query_ conn "select id from job_descriptions"
  return a
