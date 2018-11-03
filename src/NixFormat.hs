module NixFormat
    ( nixFormat
    ) where

import System.Environment
import System.Exit

import Nix.Parser
import Nix.Pretty

nixFormat :: IO ()
nixFormat = do
    (file:_) <- getArgs
    res <- parseNixFile file
    case res of
        Failure d -> die $ show d
        Success expr -> print $ prettyNix expr
