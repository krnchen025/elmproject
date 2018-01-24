module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Map
import Port



main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



type alias Model =
    { title : String
    , map : Map.Model
    , state : State
    }


type State
    = View
    | Bearbeiten




init : ( Model, Cmd Msg )
init =
    ( { title = "Karte zur Ausflugsplanung"
      , map = Map.init
      , state = View
      }
    , Map.init
        |> Map.toJsObject
        |> Port.initializeMap
    )


type Msg
    = NoOp
    | OtherMap
    | OnOtherMapDrag Map.JsObject
    | SaveOtherMap



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        OtherMap ->
            ( { model | state = Bearbeiten }
            , model.map
                |> Map.toJsObject
                |> Port.initializeEditMap
            )

        OnOtherMapDrag { lat, lng } ->
            ( { model | map = Map.modify lat lng model.map }
            , Cmd.none
            )

        SaveOtherMap ->
            ( { model | state = View }
            , model.map
                |> Map.toJsObject
                |> Port.moveMap
            )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.title ]
        ,p[] [ text <| "aktuelle Position in Koordinaten: "]
        , p[] [text <| toString (Map.toJsObject model.map) ]

        , div []
            [ div [ id "Karte" ] []
            ,button [ onClick OtherMap ] [ text "Verändern" ]
            ]

        , editView model
        ]

editView : Model -> Html Msg
editView model =
    div
        [ class <|
            case model.state of
                View ->
                    "versteckt"

                Bearbeiten ->
                    ""
        ]
        [ p [] []
        , div [ id "andere_Karte" ] []

        , button [ onClick SaveOtherMap ] [ text "Fertig" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
 Port.mapMoved OnOtherMapDrag
