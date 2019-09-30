module Main
  ( main
  ) where

import Control.Applicative (pure)
import Control.Monad (class Monad)
import Control.Monad.Except (ExceptT)
import Control.Monad.Indexed ((:*>))
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Encode.Generic.Rep (genericEncodeJson)
import Data.Array ((..))
import Data.Functor ((<$>))
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe, maybe)
import Data.Monoid ((<>))
import Data.MediaType.Common (textHTML)
import Effect (Effect)
import Effect.Aff (Aff)
import Hyper.Node.Server (defaultOptions, runServer)
import Hyper.Response (class Response, class ResponseWritable, StatusLineOpen, ResponseEnded, BodyOpen, closeHeaders, contentType, respond, writeStatus)
import Hyper.Middleware (Middleware)
import Hyper.Status (Status)
import Hyper.Conn (Conn)
import Hyper.Trout.Router (RoutingError, router)
import Prelude (class Eq, Unit, ($), show, identity, discard)
import Text.Smolder.HTML (h1, p, section)
import Text.Smolder.Markup (text)
import Type.Proxy (Proxy(..))
import Type.Trout (type (:<|>), type (:=), Resource)
import Type.Trout.ContentType.HTML (class EncodeHTML, HTML)
import Type.Trout.ContentType.JSON (JSON)
import Type.Trout.Links (linksTo)
import Type.Trout.Method (Get)

-- Exports

main :: Effect Unit
main
  = runServer defaultOptions {} siteRouter

-- Routing and error handling

resourceMap
  = { preferences: preferencesResource }

siteRouter
  = router site resourceMap (respond "Unknown route")

type Site
  = "preferences" := Resource (Get PreferencesView (HTML :<|> JSON))

site :: Proxy Site
site = Proxy

-- Application effects

type AppM a = ExceptT RoutingError Aff a

-- Models and data access

type PreferenceId = Int

newtype Preference
  = MkPreference
  { id :: PreferenceId
  , name :: String }

derive instance genericPreference :: Generic Preference _
derive instance eqPreference      :: Eq Preference

-- Views

instance genericPreferenceAsJSON  :: EncodeJson Preference where
  encodeJson = genericEncodeJson

instance encodePreferenceAsHTML   :: EncodeHTML Preference where
  encodeHTML (MkPreference { id: prefId, name }) =
    let { preferences } = linksTo site
    in section do
      h1 (text name)
      p (text $ "Contents for preference #" <> show prefId)

newtype PreferencesView = MkPreferencesView (Array Preference)

-- Resource definitions

preferencesResource
  :: { "GET" :: AppM PreferencesView }
preferencesResource
  = { "GET": MkPreferencesView <$> allPreferences }

-- allPreferences :: forall e. AppM e (Array Preference)
allPreferences
  = pure $ (\i -> MkPreference { id: i, name: "prefs-" <> show i }) <$> (1..10)
