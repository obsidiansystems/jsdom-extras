{-|
  Description:
    Constructing and manipulating javascript objects
-}
{-# Language ConstraintKinds #-}
module JSDOM.Extras.Object where

import Control.Monad
import Language.Javascript.JSaddle

type ToJSObject k v = (ToJSString k, ToJSVal v)

-- | Turn a single key, value pair into a javascript object
singleton
  :: (ToJSObject a b, MonadJSM m)
  => a
  -> b
  -> m Object
singleton k v = toObject [(k, v)]

-- | Turn a set of key, value pairs into a javascript object
toObject
  :: (MonadJSM m, ToJSObject a b)
  => [(a, b)]
  -> m Object
toObject args = liftJSM $ do
  o <- create
  let mk (k, v) = do
        v' <- toJSVal v
        setProp (toJSString k) v' o
  mapM_ mk args
  pure o

-- | Turns a javascript Object into a list of keys and values
fromObject
  :: MonadJSM m
  => Object
  -> m [(JSString, JSVal)]
fromObject o = liftJSM $ do
  keys <- listProps o
  forM keys $ \k -> do
    v <- unsafeGetProp k o
    pure (k, v)

-- | A function that does nothing
doNothing :: JSCallAsFunction
doNothing = fun $ \_ _ _ -> pure ()

-- | Lookup a key in an object. Treats both @null@s and @undefined@s as
-- 'Nothing'
lookup
  :: MonadJSM m
  => JSString
  -> Object
  -> m (Maybe JSVal)
lookup k o = liftJSM $ toMaybe =<< getProp k o

-- | Wraps a javascript value in 'Maybe', treating @undefined@ and @null@ as
-- 'Nothing'
toMaybe :: MonadJSM m => JSVal -> m (Maybe JSVal)
toMaybe a = liftJSM $ do
  resultIsUndefined <- valIsUndefined a
  resultIsNull <- valIsNull a
  pure $ if resultIsUndefined || resultIsNull then Nothing else Just a
