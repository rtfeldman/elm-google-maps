module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Date exposing (Date)
import Time exposing (Time)
import Json.Decode as Json
import Date.Format
import String
import JsonDateDecode


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = \msg m -> ( update msg m, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    Date


init : ( Model, Cmd Msg )
init =
    ( Date.fromTime 0, nowCmd UpdateDate )



-- UPDATE


type Msg
    = UpdateDate Date
    | AddADay
    | Add30Days
    | DateChanged Date


nowCmd : (Date -> a) -> Cmd a
nowCmd tagger =
    Task.perform (\_ -> tagger (Date.fromTime 0)) tagger Date.now


addTime : Time -> Date -> Date
addTime time date =
    Date.toTime date
        |> (+) time
        |> Date.fromTime


day : Time
day =
    24 * Time.hour


update : Msg -> Model -> Model
update msg model =
    case Debug.log "msg" msg of
        UpdateDate newTime ->
            newTime

        AddADay ->
            addTime day model

        Add30Days ->
            addTime (30 * day) model

        DateChanged date ->
            date


detailValue : Json.Decoder Json.Value
detailValue =
    Json.at [ "detail", "value" ] Json.value


dateValue : Json.Decoder Date
dateValue =
    Json.customDecoder detailValue JsonDateDecode.toDate


view : Model -> Html Msg
view model =
    let
        -- convert date to String in ISO8601 format
        dateString =
            JsonDateDecode.toJson model
    in
        div []
            [
             googleMap
                [ attribute "latitude" "48.2082"
                , attribute "longitude" "16.3738"
                ]
                []
            ]


googleMap : List (Attribute a) -> List (Html a) -> Html a
googleMap =
    Html.node "google-map"
