{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import           Data.Text                      ( Text )
import qualified Data.Text.Lazy.IO             as T
import           Clay
import qualified Clay.Media                    as M
import qualified Clay.Flexbox                  as FB
import           Prelude                 hiding ( all
                                                , rem
                                                , (**)
                                                )
fgColor :: Color
fgColor = "#d8dee9"

bgColor :: Color
bgColor = "#2e3440"

hoColor :: Color
hoColor = "#ebcb8b"

fonts :: [Text]
fonts = ["Montserrat", "Helvetica Neue", "Segoe UI", "Helvetica", "Arial"]

codeFonts :: [Text]
codeFonts = ["Iosevka Web", "Courier New", "Courier"]

_breakExtraSmall :: Integer
_breakExtraSmall = 575

_breakSmall :: Integer
_breakSmall = 576

_breakMedium :: Integer
_breakMedium = 768

breakLarge :: Double
breakLarge = 992

breakLargePx :: Size LengthUnit
breakLargePx = px breakLarge

_breakExtraLarge :: Integer
_breakExtraLarge = 1200


baseCss :: Css
baseCss = do
    (html <> body) ? do
        color fgColor
        sym margin  (rem 1)
        sym padding nil

    (html <> code) ? do
        fontFamily codeFonts [monospace]
        fontWeight $ weight 300

    html ? do
        fontFamily fonts [sansSerif]
        fontSize $ px 16
        overflowY auto

    body ? backgroundColor bgColor

    a ? do
        transition "color" (sec 0.2) easeOut (sec 0)
        color fgColor
        hover & color hoColor

    h1 ? fontSize (rem 9)

    h2 ? do
        fontSize (rem 3)
        fontWeight normal

    query M.screen [M.maxWidth breakLargePx] $ do
        h1 ? fontSize (vw 15)
        h2 ? fontSize (rem 2.5)

    img # byClass "logo" ? do
        boxSizing borderBox
        sym borderRadius (pct 50)
        sym2 margin (em 2) (em 3)
        width (pct 100)
        height auto
        maxWidth (px 300)
        maxHeight (px 300)


layoutCss :: Css
layoutCss = do
    main_ ? do
        element ".frontpage" ? do
            display flex
            marginTop (vh 20)
            element ".column" ? FB.flex 1 1 nil
            element ".column.left" ? textAlign end
            element ".column.right" ? do
                h1 ? do
                    marginLeft (px (-10))
                    marginBottom (em 0.4)

                h2 ? do
                    marginLeft (px (-4))
                    marginTop nil

                element ".links" ? do
                    marginTop (rem 2.5)
                    fontSize (rem 1.5)
                    a ? do
                        marginRight (rem 0.5)
                        textDecoration none
            query M.screen [M.maxWidth breakLargePx] $ do
                flexDirection column
                marginTop nil
                element ".column.left" ? textAlign center
                element ".column.right" ** h1 ? marginTop nil
                img # byClass "logo" ? sym margin nil

        element ".pgp" ? do
            let sigFontSize = 16
            display flex
            flexDirection column
            alignItems center
            element ".links" ? do
                fontSize (rem 2)
                marginTop (rem 1.5)
            code ? do
                code ? fontSize (px sigFontSize)
            query M.screen [M.maxWidth breakLargePx]
                $ fontSize (vw $ 100 * sigFontSize / breakLarge)

    footer ? do
        display flex
        marginTop (rem 3)
        fontSize (rem 0.75)
        query M.screen [M.maxWidth breakLargePx] $ flexDirection column

main :: IO ()
main = T.putStr $ renderWith compact [] $ do
    baseCss
    layoutCss
