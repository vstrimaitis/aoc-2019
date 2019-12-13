module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--


import Browser
import Html exposing (Html, button, div, text, textarea, pre, ol, li, input, span)
import Html.Events exposing (onClick, onInput)
import Html.Attributes as Attr
import Debug
import String
import List.Extra
import Maybe.Extra
import Int64



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL
type alias Vector =
    { x: Int
    , y: Int
    , z: Int
    }

type alias Planet =
    { pos: Vector
    , vel: Vector
    }

type alias Model = 
    { planets: List Planet
    , rawInput: String
    , numIterations: Int
    , partTwoAnswer: (Int, Int, Int)
    }


init : Model
init = 
    { planets = []
    , rawInput = ""
    , numIterations = 0
    , partTwoAnswer = (0, 0, 0)
    }



-- UPDATE

parsePlanet : String -> Maybe Planet
parsePlanet line =
    let
        parts = line
            |> String.slice 1 -1
            |> String.split ", "
            |> List.map (String.split "=")
            |> List.map (\part ->
                List.Extra.last part
                |> Maybe.andThen String.toInt
            )
            |> List.map (\i -> case i of
                Just x -> x
                Nothing -> -999999999
            )
    in
        case parts of
            (x::y::z::[]) -> Just { pos = { x=x, y=y, z=z}
                                  , vel = {x=0, y=0, z=0}
                                  }
            _ -> Nothing
        

parseRawInput : String -> List Planet
parseRawInput text = text
    |> String.split "\n"
    |> List.map parsePlanet
    |> Maybe.Extra.values

type Msg
  = Start1
  | Start2
  | Run1 Int
  | SetRawInput String
  | SetNumIterations String

getDirection : Int -> Int -> Int
getDirection c1 c2 =
    let d = c2-c1
    in if d < 0 then -1 else if d > 0 then 1 else 0

getVelocityDelta : Planet -> Planet -> (Int, Int, Int)
getVelocityDelta attracted attractor =
    ( getDirection attracted.pos.x attractor.pos.x
    , getDirection attracted.pos.y attractor.pos.y
    , getDirection attracted.pos.z attractor.pos.z
    )

updateVel : List Planet -> Planet -> Planet
updateVel planets p =
    let (dvx, dvy, dvz) = planets
            |> List.map (getVelocityDelta p)
            |> List.foldl (\(px, py, pz) (x, y, z) -> (px+x, py+y, pz+z)) (0, 0, 0)
    in {p | vel =
        { x = p.vel.x + dvx
        , y = p.vel.y + dvy
        , z = p.vel.z + dvz
        }}

updatePos : Planet -> Planet
updatePos p = {p | pos = 
    { x = p.pos.x+p.vel.x
    , y = p.pos.y+p.vel.y
    , z = p.pos.z+p.vel.z
    }}

doPhysics : List Planet -> List Planet
doPhysics planets = planets
    |> List.map (updateVel planets)
    |> List.map updatePos

calcEnergySingle : Planet -> Int
calcEnergySingle p = 
    let pot = (abs p.pos.x) + (abs p.pos.y) + (abs p.pos.z)
        kin = (abs p.vel.x) + (abs p.vel.y) + (abs p.vel.z)
    in pot*kin

calcEnergy : List Planet -> Int
calcEnergy planets = planets
    |> List.map calcEnergySingle
    |> List.foldl (+) 0

findPeriodInner : List Planet -> List Planet -> (Planet -> (Int, Int)) -> Int -> Int
findPeriodInner initialPlanets planets fieldFun counter =
    let initialFields = List.map fieldFun initialPlanets
        fields = List.map fieldFun planets
    in if initialFields == fields && counter > 0
        then counter + 1
        else findPeriodInner initialPlanets (doPhysics planets) fieldFun (counter+1)

findPeriod : List Planet -> (Planet -> (Int, Int)) -> Int
findPeriod planets fieldFun = findPeriodInner planets planets fieldFun 0

gcd : Int -> Int -> Int
gcd a b = if b == 0 then a else gcd b (remainderBy b a)

lcm : Int -> Int -> Int
lcm a b = a*b//(gcd a b)

solvePartTwo : List Planet -> (Int, Int, Int)
solvePartTwo planets =
    let xSteps = findPeriod planets (\p -> (p.pos.x, p.pos.x))
        ySteps = findPeriod planets (\p -> (p.pos.y, p.pos.y))
        zSteps = findPeriod planets (\p -> (p.pos.z, p.pos.z))
    in (xSteps, ySteps, zSteps)

update : Msg -> Model -> Model
update msg model =
  case msg of
    Start1 ->
        update (Run1 0) {model | planets = parseRawInput model.rawInput}

    Start2 ->
        let planets = parseRawInput model.rawInput
        in {model | planets = planets, partTwoAnswer = solvePartTwo planets}
        -- Debug.log "starting state"
        -- {model | planets = parseRawInput model.rawInput, numIterations = 0}

    SetRawInput text -> {model | rawInput = text}

    SetNumIterations it -> {model | numIterations = case (String.toInt it) of
            Just i -> i
            Nothing -> 0
        }

    Run1 iteration ->
        let it = Debug.log "#" iteration
        in if it == model.numIterations
            then Debug.log "finish" model
            else update (Run1 (iteration+1)) {model | planets = doPhysics ((Debug.log "running" model.planets))}



-- VIEW


view : Model -> Html Msg
view model =
    let planetDivs = List.map (\planet -> li []
            [ pre [] [text (Debug.toString planet)]
            ]) model.planets
        (xSteps, ySteps, zSteps) = model.partTwoAnswer
    in div []
        [ div []
            [ button [ onClick Start1 ] [ text "Run part 1" ]
            , button [ onClick Start2 ] [ text "Run part 2" ]
            , textarea [ Attr.value model.rawInput, onInput SetRawInput ] []
            , input [Attr.type_ "number", onInput SetNumIterations, Attr.value (String.fromInt model.numIterations)] []
            ]
        , ol [] planetDivs
        , div []
            [ pre [] [text "Total energy: "]
            , pre [] [text (String.fromInt (calcEnergy model.planets))]
            ]
        , div []
            [ pre [] [text "Iteration count: "]
            , pre [] [text (String.fromInt model.numIterations)]
            ]
        , div []
            [ span [] [text "Part two answer: "]
            , span [] [text "lcm("]
            , span [] [text (String.fromInt xSteps)]
            , span [] [text ", "]
            , span [] [text (String.fromInt ySteps)]
            , span [] [text ", "]
            , span [] [text (String.fromInt zSteps)]
            , span [] [text ")"]
            ]
        ]