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
    | DateChanged Json.Value


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

        DateChanged val ->
            valueToDate val |> Result.withDefault model


valueToDate : Json.Value -> Result String Date
valueToDate val =
    let
        dateString =
            toString val |> Debug.log "dateString"

        dateString' =
            if String.startsWith "<" dateString && String.endsWith ">" dateString then
                String.slice 1 -1 dateString
            else
                dateString
    in
        Date.fromString dateString' |> Debug.log "dateResult"


detailValue : Json.Decoder Json.Value
detailValue =
    Json.at [ "detail", "value" ] Json.value


onValueChanged : (Json.Value -> a) -> Attribute a
onValueChanged tagger =
    on "date-changed" <| Json.map tagger detailValue


view : Model -> Html Msg
view model =
    let
        currentDate =
            if (Date.toTime model) == 0 then
                "April 1, 2016"
            else
                Date.Format.format "%Y-%m-%d %H:%M:%S" model |> Debug.log "currentDate"
    in
        div []
            [ button [ onClick AddADay ] [ text "Add a Day" ]
            , button [ onClick Add30Days ] [ text "Add 30 Days" ]
            , Html.text (toString model)
            , br [] []
            , datePicker [ attribute "date" currentDate, onValueChanged DateChanged ] []
              --, datePicker [ attribute "date" currentDate ] []
            ]


datePicker : List (Attribute a) -> List (Html a) -> Html a
datePicker =
    Html.node "paper-date-picker"
