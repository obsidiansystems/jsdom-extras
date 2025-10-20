{-# Language LambdaCase #-}
{-# Language OverloadedStrings #-}
{-# Language ScopedTypeVariables #-}
{-|
Description:
  A facility for making sure library-defined javascript variables are ready before we use them
-}
module JSDOM.Extras.WaitForJS where

import Control.Concurrent
import Control.Lens
import Control.Monad.IO.Class
import Data.Text (Text)
import Language.Javascript.JSaddle

getGlobalJS :: MonadJSM m => Text -> m (Maybe JSVal)
getGlobalJS varName = liftJSM $ do
  window <- jsg ("window" :: Text)
  maybeNullOrUndefined =<< (window ^. js varName)

waitForGlobalJS :: MonadJSM m => Text -> m JSVal
waitForGlobalJS varName = getGlobalJS varName >>= \case
  Nothing -> liftIO (threadDelay 250000) >> waitForGlobalJS varName
  Just var -> pure var

withGlobalJS :: MonadJSM m => Text -> (JSVal -> m a) -> m a
withGlobalJS varName f = waitForGlobalJS varName >>= f
