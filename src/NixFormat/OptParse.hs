module NixFormat.OptParse where

import Options.Applicative

data Settings = Settings
    { setFile :: FilePath
    } deriving (Show, Eq)

getSettings :: IO Settings
getSettings = execParser $ info argParser (fullDesc <> progDesc "Nix Format")

argParser :: Parser Settings
argParser =
    Settings <$>
    strArgument (mconcat [metavar "FILEPATH", help "The file to format"])
