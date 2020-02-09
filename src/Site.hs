{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import           Config
import           Hakyll
import           System.Environment
import           Control.Monad.IO.Class         ( liftIO )


main :: IO ()
main = hakyll $ do

    match "config.yaml" $ do
        route mempty
        compile getResourceString

    match "css/*.hs" $ do
        route $ setExtension "css"
        compile $ getResourceString >>= withItemBody
            (unixFilter "cabal" ["v2-exec", "runghc"])

    match "css/fonts.css" $ do
        route idRoute
        compile compressCssCompiler

    match ("images/*" .||. "fonts/**") $ do
        route idRoute
        compile copyFileCompiler

    match "index.md" $ do
        route $ setExtension "html"
        compile
            $   pandocCompiler
            >>= loadAndApplyTemplate "templates/index.html" defaultCtx
            >>= relativizeUrls

    match "pgp.md" $ do
        route $ setExtension "html"
        compile
            $   pandocCompiler
            >>= loadAndApplyTemplate "templates/pgp.html" defaultCtx
            >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

defaultCtx :: Context String
defaultCtx = linksCtx <> siteNameCtx <> defaultContext

