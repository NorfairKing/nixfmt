{-# LANGUAGE RecordWildCards #-}

module NixFormat
    ( nixFormat
    ) where

import System.Environment
import System.Exit
import System.IO

import qualified Data.ByteString as SB
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE

import Text.PrettyPrint.ANSI.Leijen

import Nix.Expr
import Nix.Parser
import Nix.Pretty

import NixFormat.OptParse

nixFormat :: IO ()
nixFormat = do
    Settings {..} <- getSettings
    case setMode of
        InPlace fp -> do
            contents <- SB.readFile fp
            let res = parseNixText (TE.decodeUtf8 contents) -- TODO handle UTF8 decoding
            case res of
                Failure d -> die $ show d
                Success expr ->
                    withFile fp WriteMode $ \handle ->
                        hPutDoc handle (nixDoc expr)
        FromTo min mout -> do
            let inf func =
                    case min of
                        Nothing -> func stdin
                        Just fp -> withFile fp ReadMode func
            let outf func =
                    case mout of
                        Nothing -> func stdout
                        Just fp -> withFile fp WriteMode func
            inf $ \inh ->
                outf $ \outh -> do
                    contents <- SB.hGetContents inh
                    let res = parseNixText (TE.decodeUtf8 contents) -- TODO handle UTF8 decoding
                    case res of
                        Failure d -> die $ show d
                        Success expr -> hPutDoc outh (nixDoc expr)

nixDoc :: NExpr -> Doc
nixDoc expr = prettyNix expr <> hardline
