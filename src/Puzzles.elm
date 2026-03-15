module Puzzles exposing (..)


type alias Content =
    String


type TileGroup
    = GroupEasy
    | GroupMedium
    | GroupHard
    | GroupChallenge


type alias PuzzleGroup =
    { groupDescriptor : String
    , tiles : List Content
    }


type alias Puzzle =
    { id : String 
    , groupEasy : PuzzleGroup
    , groupMedium : PuzzleGroup
    , groupHard : PuzzleGroup
    , groupChallenge : PuzzleGroup
    }

samplePuzzle : Puzzle
samplePuzzle =
    { id = "sample"
    , groupEasy = { groupDescriptor = "Starts with A", tiles = [ "apple", "ant", "animal", "artwork" ] }
    , groupMedium = { groupDescriptor = "Starts with B", tiles = [ "banana", "bat", "brilliant", "banal" ] }
    , groupHard = { groupDescriptor = "Starts with C", tiles = [ "cinnamon", "cut", "cow", "cat" ] }
    , groupChallenge = { groupDescriptor = "Starts with D", tiles = [ "deer", "delta", "dodge", "dark" ] }
    }

template = 
    { id = ""
    , groupEasy = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
    , groupMedium = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
    , groupHard = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
    , groupChallenge = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
    }

allPuzzles : List Puzzle 
allPuzzles = 
    [ 
        { id = "2026-03-15A"
        , groupEasy = { groupDescriptor = "Acute phase reactants", tiles = [ "ferritin", "CRP", "ESR", "fibrinogen" ] }
        , groupMedium = { groupDescriptor = "Rheumatoid arthritis deformities", tiles = [ "swan neck", "Boutonniere", "Z-thumb", "ulnar drift" ] }
        , groupHard = { groupDescriptor = "Features of Haemophilia A", tiles = [ "factor VIII", "X-linked", "haemarthrosis", "prolonged APTT" ] }
        , groupChallenge = { groupDescriptor = "Adverse effects of clozapine", tiles = [ "seizures", "sialorrhoea", "constipation", "agranulocytosis" ] }
        }
    , 
        { id = "2026-03-15B"
        , groupEasy = { groupDescriptor = "Stroke mimics", tiles = [ "hypoglycaemia", "hemiplegic migraine", "functional neurological disorder", "vestibular neuritis" ] }
        , groupMedium = { groupDescriptor = "Adverse effects of SGLT2 inhibitors", tiles = [ "euglycaemic DKA", "UTI", "Fournier's gangrene", "candidiasis" ] }
        , groupHard = { groupDescriptor = "Four pillars of heart failure", tiles = [ "ACE inhibitors", "beta blockers", "SGLT2 inhibitors", "spironolactone" ] }
        , groupChallenge = { groupDescriptor = "Associated with acute abdomen", tiles = [ "hyperlactaemia", "rebound tenderness", "fever", "perforation" ] }
        }


    ]
