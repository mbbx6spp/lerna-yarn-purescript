module Main where

import Toppokki as T
import Effect (Effect)
import Prelude (Unit, bind, discard)
import Effect.Aff (launchAff_)
-- import Test.Unit.Assert as Assert
-- import Data.String as String

main :: Effect Unit
main = launchAff_ do
  browser <- T.launch {}
  page <- T.newPage browser
  T.goto (T.URL "https://example.com") page
  T.type_ (T.Selector "input#username") "username" {} page
  T.type_ (T.Selector "input#password") "password" {} page
  T.click (T.Selector "a.ping-button") page
  T.close browser
