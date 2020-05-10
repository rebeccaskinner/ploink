{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}
module Logging where
import qualified Control.Monad.IO.Class as IO
import qualified Data.IORef             as IORef
import qualified Data.Text              as Text
import qualified Data.Text.IO as Text
import System.IO.Unsafe (unsafePerformIO)

data LogLevel = LogDebug
              | LogInfo
              | LogWarning
              | LogError
              deriving (Eq, Show, Enum)

data LogConfig = LogConfig
  { logLevel :: LogLevel
  }

newtype LogMessage = LogMessage { unLogMessage :: Text.Text }
newtype Logger = Logger { runLogger :: LogMessage -> IO () }

type HasLogger = (?logger :: Logger)

systemLogger :: IORef.IORef (Maybe Logger)
systemLogger = unsafePerformIO $ IORef.newIORef Nothing

stdoutLogger :: LogConfig -> Logger
stdoutLogger cfg =
  let
    logMsg :: LogMessage -> IO ()
    logMsg (LogMessage msg) = Text.putStrLn msg
  in Logger logMsg

runWithLogger :: IO.MonadIO m => LogConfig -> (HasLogger => m a) -> m a
runWithLogger = undefined

getLogger :: HasLogger => Logger
getLogger = ?logger

log :: IO.MonadIO m => HasLogger => LogLevel -> LogMessage -> m ()
log level msg = do
  let logger = getLogger
  in runLogger logger
