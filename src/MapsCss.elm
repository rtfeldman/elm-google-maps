module MapsCss exposing (css)

import Css exposing (..)
import Css.Elements exposing (..)


css : Stylesheet
css =
    stylesheet
        [ body
            [ fontFamilies [ "Arial", "serif" ]
            , fontSize (px 18)
            , position relative
            , minWidth (px 960)
            , padding (px 20)
            ]
        , input
            [ width (px 800) ]
        , label
            [ display inlineBlock
            , padding (px 10)
            ]
        , (.) "elm-logo"
            [ position absolute
            , top (px 30)
            , right (px 30)
            , width (px 64)
            ]
        , selector "google-map"
            [ height (px 400)
            , margin (px 10)
            ]
        ]
