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
    , author : String 
    , groupEasy : PuzzleGroup
    , groupMedium : PuzzleGroup
    , groupHard : PuzzleGroup
    , groupChallenge : PuzzleGroup
    }

samplePuzzle : Puzzle
samplePuzzle =
    { id = "sample"
    , author = "n/a"
    , groupEasy = { groupDescriptor = "Starts with A", tiles = [ "apple", "ant", "animal", "artwork" ] }
    , groupMedium = { groupDescriptor = "Starts with B", tiles = [ "banana", "bat", "brilliant", "banal" ] }
    , groupHard = { groupDescriptor = "Starts with C", tiles = [ "cinnamon", "cut", "cow", "cat" ] }
    , groupChallenge = { groupDescriptor = "Starts with D", tiles = [ "deer", "delta", "dodge", "dark" ] }
    }

template = 
    { id = ""
    , author = ""
    , groupEasy = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
    , groupMedium = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
    , groupHard = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
    , groupChallenge = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
    }

allPuzzles : List Puzzle 
allPuzzles = 
    [ 
        { id = "2026-03-15A"
        , author = "DN"
        , groupEasy = { groupDescriptor = "Acute phase reactants", tiles = [ "ferritin", "CRP", "ESR", "fibrinogen" ] }
        , groupMedium = { groupDescriptor = "Rheumatoid arthritis deformities", tiles = [ "swan neck", "Boutonniere", "Z-thumb", "ulnar drift" ] }
        , groupHard = { groupDescriptor = "Features of Haemophilia A", tiles = [ "factor VIII", "X-linked", "haemarthrosis", "prolonged APTT" ] }
        , groupChallenge = { groupDescriptor = "Adverse effects of clozapine", tiles = [ "seizures", "sialorrhoea", "constipation", "agranulocytosis" ] }
        }
    , 
        { id = "2026-03-15B"
        , author = "DN"
        , groupEasy = { groupDescriptor = "Stroke mimics", tiles = [ "hypoglycaemia", "hemiplegic migraine", "functional neurological disorder", "vestibular neuritis" ] }
        , groupMedium = { groupDescriptor = "Adverse effects of SGLT2 inhibitors", tiles = [ "euglycaemic DKA", "UTI", "Fournier's gangrene", "candidiasis" ] }
        , groupHard = { groupDescriptor = "Four pillars of heart failure", tiles = [ "ACE inhibitors", "beta blockers", "SGLT2 inhibitors", "spironolactone" ] }
        , groupChallenge = { groupDescriptor = "Associated with acute abdomen", tiles = [ "hyperlactaemia", "rebound tenderness", "fever", "perforation" ] }
        }
    ,
        { id = "2026-03-15C"
        , author = "JW"
        , groupEasy = { groupDescriptor = "To enlarge", tiles = [ "distend", "dilate", "swell", "expand" ] }
        , groupMedium = { groupDescriptor = "Drugs for insomnia", tiles = [ "melatonin", "temazepam", "zolpidem", "doxylamine" ] }
        , groupHard = { groupDescriptor = "___ syndrome in pharmacology", tiles = [ "red man", "stevens-johnson", "serotonin", "neuroleptic malignant" ] }
        , groupChallenge = { groupDescriptor = "Ending in sensory organs", tiles = [ "tear", "reye", "stenose", "leopardskin" ] }
       }
    ,
        { id = "2026-03-15D"
        , author = "JW"
        , groupEasy = { groupDescriptor = "PPE", tiles = [ "mask", "gown", "glove", "shield" ] }
        , groupMedium = { groupDescriptor = "Genetic tests", tiles = [ "fish", "karyotype", "microarray", "panel" ] }
        , groupHard = { groupDescriptor = "___ tremor", tiles = [ "resting", "intention", "essential", "postural" ] }
        , groupChallenge = { groupDescriptor = "Ending in synonyms for unwell", tiles = [ "krill", "fossick", "flailing", "doff" ] }
        }

    , 
        { id = "2026-03-16"
        , author = "JW"
        , groupEasy = { groupDescriptor = "Medication frequencies", tiles = [ "MANE", "NOCTE", "MIDI", "STAT" ] }
        , groupMedium = { groupDescriptor = "___hyoid muscle", tiles = [ "OMO", "STYLO", "GENIO", "MYLO" ] }
        , groupHard = { groupDescriptor = "Bones minus \"us\"", tiles = [ "INC", "RADI", "MALLE", "TAL" ] }
        , groupChallenge = { groupDescriptor = "Ophthal lingo", tiles = [ "BRAO", "IOL", "RAPD", "OD" ] }
        }

    , 
        { id = "2026-03-17"
        , author = "JW"
        , groupEasy = { groupDescriptor = "Eponymous thyroid diseases", tiles = [ "graves", "riedel", "hashimoto", "de quervain" ] }
        , groupMedium = { groupDescriptor = "Eponymous aneuploidies", tiles = [ "turner", "down", "edwards", "patau" ] }
        , groupHard = { groupDescriptor = "Eponymous neurodegenerative disorders", tiles = [ "parkinson", "huntington", "alzheimer", "pick" ] }
        , groupChallenge = { groupDescriptor = "Eponymous tumours", tiles = [ "wilms", "ewing", "burkitt", "kaposi" ] }
        }

    , 
        { id = "2026-03-18"
        , author = "JW"
        , groupEasy = { groupDescriptor = "Antifungals", tiles = [ "nystatin", "terbinafine", "fluconazole", "amphotericin" ] }
        , groupMedium = { groupDescriptor = "Tuberculosis treatment", tiles = [ "rifampicin", "isoniazid", "pyrazinamide", "ethambutol" ] }
        , groupHard = { groupDescriptor = "First-line H. pylori drugs", tiles = [ "amoxicillin", "clarithromycin", "esomeprazole", "metronidazole" ] }
        , groupChallenge = { groupDescriptor = "Common UTI therapeutics", tiles = [ "nitrofurantoin", "trimethoprim", "cephalexin", "fosfomycin" ] }
        }
    , 
        { id = "2026-03-19"
        , author = ""
        , groupEasy = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
        , groupMedium = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
        , groupHard = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
        , groupChallenge = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
        }
    , 
        { id = "2026-03-20"
        , author = ""
        , groupEasy = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
        , groupMedium = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
        , groupHard = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
        , groupChallenge = { groupDescriptor = "", tiles = [ "", "", "", "" ] }
        }


    ]
    |> List.sortBy .id 
    |> List.reverse
