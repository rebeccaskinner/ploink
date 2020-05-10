{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module App where

import qualified Config               as Config
import           Control.Monad.Except
import           Control.Monad.Fail
import           Control.Monad.Reader

data PloinkError = PloinkErrorUnknown (Maybe String)
    deriving (Eq, Show)

newtype Ploink m a = Ploink
  { runPloink :: ExceptT PloinkError (ReaderT Config.PloinkConfig m) a }
  deriving ( Functor
           , Applicative
           , Monad
           , MonadIO
           , MonadError PloinkError
           , MonadReader Config.PloinkConfig
           )


raiseAppException :: (Monad m, MonadFail m) => Either PloinkError a -> m a
raiseAppException e = case e of
  Left err -> Control.Monad.Fail.fail . show $ err
  Right a  -> return a

runApp :: (Monad m, MonadFail m) => Config.PloinkConfig -> Ploink m a -> m a
runApp cfg = (>>= raiseAppException) . runApp' cfg

runApp' :: (Monad m, MonadFail m) => Config.PloinkConfig -> Ploink m a -> m (Either PloinkError a)
runApp' cfg = flip runReaderT cfg . runExceptT . runPloink
