module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Date exposing (Date)
import Time exposing (Time)
import Json.Decode as Json


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
    | DateChanged String


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
            Debug.log val model


detailValue : Json.Decoder String
detailValue =
    Json.at [ "detail", "date" ] Json.string


onValueChanged : (String -> a) -> Attribute a
onValueChanged tagger =
    on "date-changed" <| Json.map tagger detailValue


view : Model -> Html Msg
view model =
    let
        currentDate =
            if (Date.toTime model) == 0 then
                "2016-08-27"
            else
                toString model
    in
        div []
            [ button [ onClick AddADay ] [ text "Add a Day" ]
            , button [ onClick Add30Days ] [ text "Add 30 Days" ]
            , br [] []
            , datePicker [ attribute "date" currentDate, onValueChanged DateChanged ] []
            ]


datePicker : List (Attribute a) -> List (Html a) -> Html a
datePicker =
    Html.node "paper-date-picker"
