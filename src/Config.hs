{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Config (siteNameCtx, linksCtx) where

import           Data.Maybe                     ( fromMaybe )
import qualified Data.Text                     as T
import           Data.Yaml
import           Data.Aeson.Key                 ( fromString )
import           Hakyll

siteNameCtx :: Context String
siteNameCtx = field "siteName" $ \_ ->
    fromMaybe "Site Name" . lookupString "siteName" <$> getMetadata
        "config.yaml"

linkCtx :: Context Object
linkCtx = Context $ \k _ i -> do
    pure $ StringField $ either error id $ parseEither (.: fromString k)
                                                       (itemBody i)

linksCtx :: Context a
linksCtx = listFieldWith "links" linkCtx is
  where
    is i = do
        m <- getMetadata (itemIdentifier i)
        sequenceA $ makeItem <$> fromMaybe [] (parseMaybe lnkP m)
    lnkP o = (o .: "links") >>= parseJSONList
