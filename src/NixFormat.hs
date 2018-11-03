{-# LANGUAGE RecordWildCards #-}

module NixFormat
    ( nixFormat
    ) where

import System.Environment
import System.Exit

import Nix.Parser
import Nix.Pretty

import NixFormat.OptParse

nixFormat :: IO ()
nixFormat = do
    Settings {..} <- getSettings
    res <- parseNixFile setFile
    case res of
        Failure d -> die $ show d
        Success expr -> print $ prettyNix expr
