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


valueToDate : Json.Value -> Json.Decoder Date
valueToDate value =
    case JsonDateDecode.toDate value of
        Ok date ->
            Json.succeed date

        Err error ->
            Json.fail error


onValueChanged : (Date -> a) -> Attribute a
onValueChanged tagger =
    on "date-changed" <| Json.map tagger (detailValue `Json.andThen` valueToDate)


view : Model -> Html Msg
view model =
    let
        -- convert date to String in ISO8601 format
        dateString =
            JsonDateDecode.toJson model
    in
        div []
            [ button [ onClick AddADay ] [ text "Add a Day" ]
            , button [ onClick Add30Days ] [ text "Add 30 Days" ]
            , Html.p [] [ Html.text (toString model) ]
            , datePicker [ attribute "date" dateString, onValueChanged DateChanged ] []
            ]


datePicker : List (Attribute a) -> List (Html a) -> Html a
datePicker =
    Html.node "paper-date-picker"
