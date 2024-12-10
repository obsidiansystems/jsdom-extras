{-|
  Description:
    Platform-independent JSON-to-JSVal and JSVal-to-JSON functions
-}
{-# Language CPP #-}
{-# Language OverloadedStrings #-}
module JSDOM.Extras.JSON where

import Control.Lens
import Data.Aeson
import Language.Javascript.JSaddle
#ifndef ghcjs_HOST_OS
import Language.Javascript.JSaddle.Native.Internal (jsonValueToValue, valueToJSONValue)
#endif

-- | Convert a JSON 'Value' to 'JSVal'
jsValFromJSON :: Value -> JSM JSVal
#ifdef ghcjs_HOST_OS
jsValFromJSON = toJSVal
#else
jsValFromJSON = jsonValueToValue
#endif

-- | Try to convert a 'JSVal' to a JSON 'Value'
jsValToJSON :: JSVal -> JSM (Maybe Value)
#ifdef ghcjs_HOST_OS
jsValToJSON = fromJSVal
#else
jsValToJSON = fmap Just . valueToJSONValue
#endif

-- | <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify JSON.stringify>
stringify :: (MonadJSM m) => JSVal -> m JSString
stringify arg = liftJSM $ fromJSValUnchecked =<< jsg ("JSON"::JSString) ^. js1 ("stringify"::JSString) arg

-- | <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/parse JSON.parse>
parse :: (MonadJSM m) => JSVal -> m JSVal
parse arg = liftJSM $ jsg ("JSON"::JSString) ^. js1 ("parse"::JSString) arg

