module Map exposing (Model, JsObject, init, modify, toJsObject)


type Model
    = Internal
        { latitude : Float
        , longtitude : Float
        }


init : Model
init =
    Internal
        { latitude = 51.4825041
        , longtitude = 11.9705452
        }


modify : Float -> Float -> Model -> Model
modify latitude longtitude (Internal model) =
    Internal
        { model
            | latitude = latitude
            , longtitude = longtitude
        }


type alias JsObject =
    { lat : Float
    , lng : Float
    }


toJsObject : Model -> JsObject
toJsObject (Internal model) =
    { lat = model.latitude
    , lng = model.longtitude}
