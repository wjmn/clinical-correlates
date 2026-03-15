module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Extra
import Maybe.Extra
import Random
import Random.Extra
import Random.List
import Set
import Puzzles exposing (..)



---- MODEL ----




type alias InterfaceTile =
    { content : Content
    , group : TileGroup
    , selected : Bool
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
        |> List.map (\c -> { content = c, group = group, selected = False })


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
            initialiseModel (List.Extra.last allPuzzles |> Maybe.withDefault samplePuzzle)
    in
    ( initialModel, Random.generate ShuffledTiles (Random.List.shuffle initialModel.tiles) )



---- UPDATE ----


type Msg
    = NoOp
    | ShuffledTiles (List InterfaceTile)
    | ClickedTile InterfaceTile
    | ClickedSubmit
    | ClickedShuffle
    | ClickedPuzzle Puzzle


withCmd cmd model =
    ( model, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShuffledTiles shuffled ->
            { model | tiles = shuffled }
                |> withCmd Cmd.none

        ClickedTile clickedTile ->
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
                            { model | tiles = updatedTiles, solvedRows = solvedRows, message = Just "Nice one!" }
                                |> withCmd Cmd.none

                        else
                            { model | tiles = updatedTiles, solvedRows = solvedRows, solveState = Won, message = Nothing }
                                |> withCmd Cmd.none

                    _ ->
                        let
                            unselectedTiles =
                                List.map (\t -> { t | selected = False }) model.tiles

                            remainingTries =
                                model.remainingTries - 1

                            newMessage = 
                                case model.message of 
                                    Just "Not quite!" -> Just "Nope!"
                                    Just "Nope!" -> Just "Not quite!"
                                    _ -> Just "Not quite!"
                        in
                        if remainingTries > 0 then
                            { model | tiles = unselectedTiles, remainingTries = remainingTries, message = newMessage }
                                |> withCmd Cmd.none

                        else
                            { model | tiles = unselectedTiles, solveState = Lost, remainingTries = remainingTries, message = Just "You lost :( No answers for you!"}
                                |> withCmd Cmd.none

            else
                model |> withCmd Cmd.none

        ClickedShuffle ->
            model
                |> withCmd (Random.generate ShuffledTiles (Random.List.shuffle model.tiles))
        
        ClickedPuzzle puzzle -> 
            let
                initialModel =
                    initialiseModel puzzle 
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
            div [ class "grid-tile", classList [ ( "is-selected", tile.selected ) ], onClick (ClickedTile tile) ]
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
            if numSelected < 4 then
                True

            else
                False

        viewPuzzle puzzle = 
            div [class "other-puzzle-button", onClick (ClickedPuzzle puzzle)] [text puzzle.id]
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
            , div [class "puzzle-id" ][ text <| model.puzzle.id ]
            , div [ class "subtitle"] [ text <| "Make four groups of four!"]
            , div [ class "grid-container" ]
                [ div [ class "grid" ]
                    (List.concat
                        [ List.map viewSolvedRow model.solvedRows
                        , List.map viewTile model.tiles
                        ]
                    )
                ]
            , div [class "num-remaining"]
                (List.repeat model.remainingTries (div  [class "remaining-try"] []))
            , div [ class "button-row" ]
                [ button [ class "submit-button", onClick ClickedSubmit, disabled submitButtonDisabled, classList [ ( "disabled", submitButtonDisabled ) ] ]
                    [ text "Submit" ]
                , button [ class "shuffle-button", onClick ClickedShuffle ] [ text "Shuffle" ]
                ]
            , div [ class "message-row" ]
                [ messageDiv ]
            , div [class "other-puzzles"]
                [div [class "other-puzzles-header"] [text "All dates:"]
                , div [class "other-puzzles-container"] (List.map viewPuzzle allPuzzles)]
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
