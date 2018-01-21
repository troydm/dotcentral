import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders
import XMonad.Util.WindowProperties
import XMonad.Layout.LayoutModifier
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.ConfirmPrompt
import Control.Monad
import Data.Monoid
import qualified XMonad.DBus as D
import qualified XMonad.StackSet as W
import Data.Maybe (fromMaybe)
import Data.List (isInfixOf)
import System.Exit (exitWith,ExitCode(..))

recompileAndRestart = spawn "cd ~/.xmonad; if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"


myModMask = mod4Mask
myTerminal = "urxvt"
myLauncher = "rofi -show-icons -theme ~/.dotcentral/configurations/common/rofi/zenburn.rofi -show drun"

myStartup :: X ()
myStartup = do
              spawn "feh --bg-fill ~/.wallpapers/snow.jpeg"
              spawn "setxkbmap -layout us,ru,ge -option altwin:swap_lalt_lwin -option grp:win_space_toggle"
              spawnOnce "compton"
              spawnOnce "redshift"
              spawnOnce "polybar snow"

myKeys = [("M-<Return>", spawn myTerminal)
         ,("S-M-<Return>", windows W.swapMaster)
         ,("M-d", spawn myLauncher)
         ,("M-`", spawn myLauncher)
         ,("C-M-h", sendMessage Shrink)
         ,("C-M-l", sendMessage Expand)
         ,("C-M-j", sendMessage MirrorShrink)
         ,("C-M-k", sendMessage MirrorExpand)
         ,("M-h", windows W.focusUp)
         ,("M-k", windows W.focusUp)
         ,("M-<Left>", windows W.focusUp)
         ,("M-<Up>", windows W.focusUp)
         ,("S-M-h", windows W.swapUp)
         ,("S-M-k", windows W.swapUp)
         ,("S-M-<Left>", windows W.swapUp)
         ,("S-M-<Up>", windows W.swapUp)
         ,("M-l", windows W.focusDown)
         ,("M-j", windows W.focusDown)
         ,("M-<Right>", windows W.focusDown)
         ,("M-<Down>", windows W.focusDown)
         ,("S-M-l", windows W.swapDown)
         ,("S-M-j", windows W.swapDown)
         ,("S-M-<Right>", windows W.swapDown)
         ,("S-M-<Down>", windows W.swapDown)
         ,("M-w", sendMessage NextLayout)
         ,("M-f", sendMessage (Toggle "Full"))
         ,("M-q", kill)
         ,("S-M-q", confirmPrompt myPrompt "exit" $ io (exitWith ExitSuccess))
         ,("S-M-r", recompileAndRestart)
         ,("C-M-x", shellPrompt myPrompt)
         ]
myRemoveKeys = ["M-<Space>","S-M-<Space>"]

myBorderWidth = 2
myNormalBorderColor  = "#333333"
myFocusedBorderColor = "#FFFFFF"

mySpacing = smartSpacing 5
myGaps = gaps [(U,5),(L,10),(R,10),(D,10)]
myFull = mySpacing $ Full
myTall = mySpacing $ ResizableTall 1 (5/100) (1/2) []
myTabbed = tabbed shrinkText (def { fontName = "xft:DejaVu Sans Mono:pixelsize=13:antialias=true" 
                                  , activeColor = "#3F3F3F"
                                  , activeBorderColor = "#000"
                                  , inactiveColor = "#000"
                                  , inactiveBorderColor = "#000"
                                    })
myToggle = toggleLayouts (noBorders Full) (avoidStruts . myGaps $ myTall ||| Mirror myTall ||| myTabbed ||| myFull)
myLayout = myToggle

myManageHook = composeAll [
                    manageHook def
                ]

myFullscreenEventHook :: Event -> X All
myFullscreenEventHook (ClientMessageEvent _ _ _ dpy win typ (action:dats)) = do
    wmstate <- getAtom "_NET_WM_STATE"
    fullsc <- getAtom "_NET_WM_STATE_FULLSCREEN"
    above <- getAtom "_NET_WM_STATE_ABOVE"
    below <- getAtom "_NET_WM_STATE_BELOW"
    when (typ == wmstate && (fromIntegral fullsc) `elem` dats) $ do
        winset <- gets windowset
        let layout = description . W.layout . W.workspace . W.current $ winset
        when (action == 1) $ sendMessage (Toggle "Full")
        when (action == 0 && layout == "Full") $ sendMessage (Toggle "Full")
    return $ All True

myFullscreenEventHook (DestroyWindowEvent {ev_window = w}) = do
    winset <- gets windowset
    let layout = description . W.layout . W.workspace . W.current $ winset
    when (layout == "Full") $ sendMessage (Toggle "Full")
    return $ All True

myFullscreenEventHook _ = return $ All True

myLogHook dbus = def {
      ppOutput = D.send dbus
    , ppTitle = shorten 50
    , ppSep = " \xf142 "
    , ppWsSep = ""
    , ppCurrent = \i -> "\xf053"++(w i)++"\xf054"
    , ppHidden = \i -> " "++(w i)++" "
    , ppLayout = (\l ->
        if "Full" `isInfixOf` l then "\xf26c"
        else if "Mirror" `isInfixOf` l then "\xf17a"
        else if "Tabbed" `isInfixOf` l then "\xf114"
        else "\xf009"
        )
    }
    where w i = if i == "1" then "\xf120" 
                else if i == "2" then "\xf269"
                else if i == "3" then "\xf15b"
                else i

myPrompt = def {
      font = "xft:DejaVu Sans Mono for Powerline:pixelsize=13"
    , bgColor = "#3f3f3f"
    , fgColor = "#f0dfaf"
    , bgHLight = "#000000"
    , fgHLight = "#bfebbf"
    , height = 25
    }

main = do
        dbus <- D.connect
        D.requestAccess dbus
        xmonad . docks $ def { startupHook = myStartup
                    , modMask = myModMask
                    , terminal = myTerminal
                    , borderWidth = myBorderWidth
                    , normalBorderColor  = myNormalBorderColor
                    , focusedBorderColor = myFocusedBorderColor
                    , layoutHook = myLayout
                    , manageHook = myManageHook
                    , handleEventHook = myFullscreenEventHook
                    , logHook = dynamicLogWithPP (myLogHook dbus)
                    } `removeKeysP` myRemoveKeys `additionalKeysP` myKeys

