import XMonad
import XMonad.Config.Kde
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops


main = do
    xmonad $ myConfig


myManageHook = composeAll
  [ className =? "yakuake" --> doFloat  
  , className =? "Yakuake" --> doFloat  
  , className =? "Kmix" --> doFloat  
  , className =? "kmix" --> doFloat  
  , className =? "plasma" --> doFloat  
  , className =? "Plasma" --> doFloat  
  , className =? "plasma-desktop" --> doFloat  
  , className =? "Plasma-desktop" --> doFloat  
  , className =? "krunner" --> doFloat  
  , className =? "ksplashsimple" --> doFloat  
  , className =? "ksplashqml" --> doFloat  
  , className =? "ksplashx" --> doFloat  
  , className =? "plasmashell" --> doFloat  
  ]  

myConfig = kdeConfig
        { modMask = mod4Mask     -- Rebind Mod to the Windows key
        , manageHook = manageDocks <+> myManageHook <+> manageHook kdeConfig
        , layoutHook = avoidStruts  $  layoutHook kdeConfig
        , handleEventHook    = fullscreenEventHook
        }
