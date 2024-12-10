{-|
  Description:
    Logging in javascript via console.log. This doesn't require a 'Show'
    instance or any other conversion of the JSVal to be shown.
-}
{-# Language OverloadedStrings #-}
module JSDOM.Extras.ConsoleLog where

import Prelude hiding (log)

import Control.Lens
import Control.Monad
import Language.Javascript.JSaddle

-- | <https://developer.mozilla.org/en-US/docs/Web/API/Console/log console.log>
consoleLog :: (MonadJSM m, ToJSVal a) => a -> m ()
consoleLog arg = void $ liftJSM $ jsg console ^. js1 log arg
  where
    console, log :: JSString
    console = "console"
    log = "log"
