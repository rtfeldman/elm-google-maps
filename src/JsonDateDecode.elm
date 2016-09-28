module JsonDateDecode exposing (toDate, toJson)

import Date exposing (Date)
import Json.Decode
import Native.JsonDateDecode


{-| Try to interpret a Json.Decode.Value as a Date. Json.Decode does not provide
    for this so we roll our own.
-}
toDate : Json.Decode.Value -> Result String Date
toDate =
    Native.JsonDateDecode.toDate

toJson : Date -> String
toJson =
    Native.JsonDateDecode.toJson

