module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Extra
import Maybe.Extra
import Puzzles exposing (..)
import Random
import Random.Extra
import Random.List
import Set
import Task
import Process



---- MODEL ----


type alias InterfaceTile =
    { content : Content
    , group : TileGroup
    , selected : Bool
    , shaking : Bool
    , jumping : Bool
    }


type SolveState
    = InProgress
    | Won
    | Lost


type alias Model =
    { tiles : List InterfaceTile
    , remainingTries : Int
    , solvedRows : List ( TileGroup, PuzzleGroup )
    , solveState : SolveState
    , puzzle : Puzzle
    , message : Maybe String
    }


toTilesWithGroup : TileGroup -> List Content -> List InterfaceTile
toTilesWithGroup group tiles =
    tiles
        |> List.map (\c -> { content = c, group = group, selected = False, shaking = False, jumping = False})


puzzleToInitialTiles : Puzzle -> List InterfaceTile
puzzleToInitialTiles puzzle =
    let
        easyTiles =
            toTilesWithGroup GroupEasy puzzle.groupEasy.tiles

        mediumTiles =
            toTilesWithGroup GroupMedium puzzle.groupMedium.tiles

        hardTiles =
            toTilesWithGroup GroupHard puzzle.groupHard.tiles

        challengeTiles =
            toTilesWithGroup GroupChallenge puzzle.groupChallenge.tiles
    in
    List.concat [ easyTiles, mediumTiles, hardTiles, challengeTiles ]


initialiseModel : Puzzle -> Model
initialiseModel puzzle =
    { tiles = puzzleToInitialTiles puzzle
    , remainingTries = 4
    , solvedRows = []
    , solveState = InProgress
    , puzzle = puzzle
    , message = Nothing
    }


init : ( Model, Cmd Msg )
init =
    let
        initialModel =
            initialiseModel (List.head allPuzzles |> Maybe.withDefault samplePuzzle)
    in
    ( initialModel, Random.generate ShuffledTiles (Random.List.shuffle initialModel.tiles) )



---- UPDATE ----


type Msg
    = NoOp
    | ShuffledTiles (List InterfaceTile)
    | ClickedTile InterfaceTile
    | UnshakeAllTiles
    | JumpTilesThenNewModel Model
    | ClickedSubmit
    | ClickedShuffle
    | ClickedPuzzle Puzzle
    | ClickedRestart


withCmd cmd model =
    ( model, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShuffledTiles shuffled ->
            { model | tiles = shuffled }
                |> withCmd Cmd.none

        ClickedTile clickedTile ->
            case model.solveState of 
            InProgress -> 
                if clickedTile.selected then
                    let
                        newTiles =
                            List.map
                                (\t ->
                                    if t == clickedTile then
                                        { t | selected = not t.selected }

                                    else
                                        t
                                )
                                model.tiles
                    in
                    { model | tiles = newTiles }
                        |> withCmd Cmd.none

                else
                    let
                        numClicked =
                            List.filter .selected model.tiles |> List.length
                    in
                    if numClicked >= 4 then
                        model |> withCmd Cmd.none

                    else
                        let
                            newTiles =
                                List.map
                                    (\t ->
                                        if t == clickedTile then
                                            { t | selected = not t.selected }

                                        else
                                            t
                                    )
                                    model.tiles
                        in
                        { model | tiles = newTiles }
                            |> withCmd Cmd.none
            _ -> (model, Cmd.none)

        ClickedSubmit ->
            let
                selected =
                    List.filter .selected model.tiles

                groupSelected =
                    List.map .group selected

                uniqueGroups =
                    List.Extra.unique groupSelected
            in
            if List.length selected == 4 then
                case uniqueGroups of
                    [ onlyGroup ] ->
                        let
                            updatedTiles =
                                List.filter (\t -> t.group /= onlyGroup) model.tiles

                            solvedRow =
                                case onlyGroup of
                                    GroupEasy ->
                                        model.puzzle.groupEasy

                                    GroupMedium ->
                                        model.puzzle.groupMedium

                                    GroupHard ->
                                        model.puzzle.groupHard

                                    GroupChallenge ->
                                        model.puzzle.groupChallenge

                            solvedRows =
                                model.solvedRows ++ [ ( onlyGroup, solvedRow ) ]
                        in
                        if List.length updatedTiles > 0 then
                            let
                                newModel = { model | tiles = updatedTiles, solvedRows = solvedRows, message = Just "Nice one!" }
                                modelWithJumping = 
                                    { model | tiles = List.map (\x -> if x.selected then { x | jumping = True} else x) model.tiles }
                            in
                                modelWithJumping
                                |> withCmd (Task.perform (\_ -> JumpTilesThenNewModel newModel) <| Process.sleep 500)

                        else
                            { model | tiles = updatedTiles, solvedRows = solvedRows, solveState = Won, message = Nothing }
                                |> withCmd Cmd.none

                    _ ->
                        let

                            unselectedTilesWithShaking =
                                model.tiles
                                |> List.map (\t -> if t.selected then { t | selected = False, shaking=True } else t)
                            unselectedTiles =
                                model.tiles
                                |> List.map (\t -> { t | selected = False })

                            remainingTries =
                                model.remainingTries - 1

                            newMessage =
                                let
                                    numEasy = List.filter ((==) GroupEasy) groupSelected |> List.length
                                    numMed = List.filter ((==) GroupMedium) groupSelected |> List.length 
                                    numHard = List.filter ((==) GroupHard) groupSelected  |> List.length
                                    numChallenge = List.filter((==) GroupChallenge) groupSelected |> List.length
                                    maxNum = List.maximum [numEasy, numMed, numHard, numChallenge] |> Maybe.withDefault 0
                                in
                                
                                if maxNum == 3 then 
                                    Just "Three out of four. So close..."
                                else
                                    case model.message of
                                        Just "Not quite!" ->
                                            Just "Nope!"

                                        Just "Nope!" ->
                                            Just "Not quite!"

                                        _ ->
                                            Just "Not quite!"
                        in
                        if remainingTries > 0 then
                            { model | tiles = unselectedTilesWithShaking, remainingTries = remainingTries, message = newMessage }
                                    |> withCmd (Task.perform (\_ -> UnshakeAllTiles) <|  (Process.sleep 300) )

                        else
                            { model | tiles = unselectedTiles, solveState = Lost, remainingTries = remainingTries, message = Just "You lost :( No answers for you!" }
                                |> withCmd Cmd.none

            else
                model |> withCmd Cmd.none

        ClickedShuffle ->
            model
                |> withCmd (Random.generate ShuffledTiles (Random.List.shuffle model.tiles))

        UnshakeAllTiles -> 
            let
                updatedTiles = List.map (\t -> { t | shaking = False}) model.tiles
            in
            { model | tiles = updatedTiles}
            |> withCmd Cmd.none

        JumpTilesThenNewModel newModel -> 
            newModel 
            |> withCmd Cmd.none
            

        ClickedPuzzle puzzle ->
            let
                initialModel =
                    initialiseModel puzzle
            in
            ( initialModel, Random.generate ShuffledTiles (Random.List.shuffle initialModel.tiles) )

        ClickedRestart -> 
            let
                initialModel =
                    initialiseModel model.puzzle
            in
            ( initialModel, Random.generate ShuffledTiles (Random.List.shuffle initialModel.tiles) )



        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


groupToString group =
    case group of
        GroupEasy ->
            "group-easy"

        GroupMedium ->
            "group-medium"

        GroupHard ->
            "group-hard"

        GroupChallenge ->
            "group-challenge"


view : Model -> Html Msg
view model =
    let
        viewSolvedRow ( group, puzzleGroup ) =
            div [ class "solved-row", classList [ ( groupToString group, True ) ] ]
                [ div [ class "solved-row-header" ] [ text puzzleGroup.groupDescriptor ]
                , div [ class "solved-row-words" ] [ text <| String.join ", " puzzleGroup.tiles ]
                ]

        viewTile tile =
            div
                [ class "grid-tile"
                , classList
                    [ ( "is-selected", tile.selected )
                    , ( "is-shaking", tile.shaking )
                    , ( "is-jumping", tile.jumping)
                    ]
                , onClick (ClickedTile tile)
                ]
                [ text tile.content ]

        messageDiv =
            case model.message of
                Nothing ->
                    div [] []

                Just message ->
                    div [ class "message" ] [ text message ]

        statusClass =
            case model.solveState of
                InProgress ->
                    "status-in-progress"

                Won ->
                    "status-won"

                Lost ->
                    "status-lost"

        numSelected =
            List.filter .selected model.tiles
                |> List.length

        submitButtonDisabled =
            case model.solveState of 
                InProgress -> 
                    if numSelected < 4 then
                        True

                    else
                        False
                _ -> False

        viewPuzzle puzzle =
            div [ class "other-puzzle-button", onClick (ClickedPuzzle puzzle) ] [ text puzzle.id ]

        (submitText, submitAction) = 
            case model.solveState of 
                InProgress -> ("Submit", ClickedSubmit)
                _ -> ("Restart", ClickedRestart)

    in
    div [ class "outer-container" ]
        [ div [ id "game-status", class statusClass ]
            [ div [ class "firework-container", classList [ ( "show", statusClass == "status-won" ) ] ]
                [ div [ class "firework" ] []
                , div [ class "firework" ] []
                , div [ class "firework" ] []
                ]
            , div
                [ class "flash"
                , class statusClass
                , classList [ ( "show", statusClass == "status-won" || statusClass == "status-lost" ) ]
                ]
                []
            ]
        , div [ class "inner-container" ]
            [ div [ class "header" ] [ text "Clinical Correlates" ]
            , div [ class "puzzle-id" ] [ text <| model.puzzle.id ]
            , div [ class "subtitle" ] [ text <| "Make four groups of four!" ]
            , div [ class "grid-container" ]
                [ div [ class "grid" ]
                    (List.concat
                        [ List.map viewSolvedRow model.solvedRows
                        , List.map viewTile model.tiles
                        ]
                    )
                ]
            , div [ class "num-remaining" ]
                (List.repeat model.remainingTries (div [ class "remaining-try" ] []))
            , div [ class "button-row" ]
                [ button [ class "submit-button", onClick submitAction, disabled submitButtonDisabled, classList [ ( "disabled", submitButtonDisabled ) ] ]
                    [ text submitText ]
                , button [ class "shuffle-button", onClick ClickedShuffle ] [ text "Shuffle" ]
                ]
            , div [ class "message-row" ]
                [ messageDiv ]
            , div [ class "other-puzzles" ]
                [ div [ class "other-puzzles-header" ] [ text "All dates:" ]
                , div [ class "other-puzzles-container" ] (List.map viewPuzzle allPuzzles)
                ]
            ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
