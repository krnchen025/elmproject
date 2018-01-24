port module Port exposing (..)

import Map



port initializeMap : Map.JsObject -> Cmd msg


port initializeEditMap : Map.JsObject -> Cmd msg


port moveMap : Map.JsObject -> Cmd msg


port mapMoved : (Map.JsObject -> msg) -> Sub msg
