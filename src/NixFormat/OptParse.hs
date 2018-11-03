module NixFormat.OptParse where

import Options.Applicative

data Settings = Settings
    { setMode :: Mode
    } deriving (Show, Eq)

data Mode
    = InPlace FilePath
    | FromTo (Maybe FilePath)
             (Maybe FilePath)
    deriving (Show, Eq)

getSettings :: IO Settings
getSettings =
    customExecParser prefs $
    info (helper <*> argParser) (fullDesc <> progDesc "Nix Format")
  where
    prefs = defaultPrefs

argParser :: Parser Settings
argParser = Settings <$> modeParser

modeParser :: Parser Mode
modeParser = fromToParser <|> inPlaceParser

inPlaceParser :: Parser Mode
inPlaceParser =
    InPlace <$>
    (snd <$>
     ((,) <$> flag' () (mconcat [long "in-place", short 'i']) <*>
      strArgument
          (mconcat [metavar "FILE1", help "The file to format in-place"])))

fromToParser :: Parser Mode
fromToParser =
    FromTo <$>
    (argument
         (Just <$> str)
         (mconcat
              [ metavar "FILE2"
              , help "The file to format, use stdin if not given"
              , value Nothing
              ])) <*>
    (option
         (Just <$> str)
         (mconcat
              [ short 'o'
              , long "output"
              , metavar "FILEPATH"
              , help
                    "The file to write the result to, write to stdout if not given"
              , value Nothing
              ]))
