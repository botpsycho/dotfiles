  -- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

   -- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask

myTerminal :: String
myTerminal = "st"

myBrowser :: String
myBrowser = "qutebrowser"

myEmacs :: String
myEmacs = "emacsclient -c -a 'emacs' "

myEditor :: String
myEditor = "emacsclient -c -a 'emacs' "

myBorderWidth :: Dimension
myBorderWidth = 2

myNormColor :: String
myNormColor   = "#282c34"

myFocusColor :: String
myFocusColor  = "#46d9ff"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "nm-applet"
    spawnOnce "volumeicon"
    spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 22 &"
    spawnOnce "xsetroot -cursor_name left_ptr"
    setWMName "LG3D"

myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                , NS "calculator" spawnCalc findCalc manageCalc
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -t mocp -e mocp"
    findMocp   = title =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "tall"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 4
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 4
           $ mkToggle (single MIRROR)
           $ Grid (16/10)

myTabTheme = def { fontName            = myFont
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout =     withBorder myBorderWidth tall
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| grid

myWorkspaces = [" dev ", " web ", " file ", " mail ", " rss ", " music ", " video ", " vbox ", " others "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..]

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     [ className =? "confirm"         --> doFloat
     , className =? "file_progress"   --> doFloat
     , className =? "dialog"          --> doFloat
     , className =? "download"        --> doFloat
     , className =? "error"           --> doFloat
     , className =? "Gimp"            --> doFloat
     , className =? "notification"    --> doFloat
     , className =? "pinentry-gtk-2"  --> doFloat
     , className =? "splash"          --> doFloat
     , className =? "toolbar"         --> doFloat
     , className =? "Yad"             --> doCenterFloat
     , className =? "qutebrowser"   --> doShift ( myWorkspaces !! 1 )
     , className =? "Brave-browser"   --> doShift ( myWorkspaces !! 1 )
     , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
     , isFullscreen -->  doFullFloat
     ] <+> namedScratchpadManageHook myScratchPads

-- START_KEYS
myKeys :: [(String, X ())]
myKeys =
    -- KB_GROUP Power Management
        [ ("M-S-r", spawn "reboot")
    -- KB_GROUP Xmonad
        , ("M-C-r", spawn "xmonad --restart")
        , ("M-M1-r", spawn "xmonad --recompile")

    -- KB_GROUP Run Prompt
        , ("M-<Space>", spawn "dmenu_run -i -p \"Run: \"") -- Dmenu

    -- KB_GROUP Other Dmenu Prompts
        , ("M-p h", spawn "dm-hub")
        , ("M-p a", spawn "dm-sounds")
        , ("M-p b", spawn "dm-setbg")
        , ("M-p c", spawn "dm-colpick")
        , ("M-p e", spawn "dm-confedit")
        , ("M-p i", spawn "dm-maim")
        , ("M-p k", spawn "dm-kill")
        , ("M-p m", spawn "dm-man")
        , ("M-p n", spawn "dm-note")
        , ("M-p o", spawn "dm-bookman")
        , ("M-p p", spawn "passmenu")
        , ("M-p q", spawn "dm-logout")
        , ("M-p r", spawn "dm-reddit")
        , ("M-p s", spawn "dm-websearch")
        , ("M-p t", spawn "dm-translate")

    -- KB_GROUP Programs
        , ("M-<Return>", spawn (myTerminal))
        , ("M-b", spawn (myBrowser))
        , ("M-v", spawn (myTerminal ++ " -e nvim"))
        , ("M-r", spawn (myTerminal ++ " -e lf"))
        , ("M-m", spawn (myTerminal ++ " -e mocp"))
        , ("M-S-l", spawn ("i3lock-fancy"))
        , ("M-M1-h", spawn (myTerminal ++ " -e htop"))

    -- KB_GROUP scripts
        , ("M1-c", spawn ("wifi-connect"))
        , ("M1-p", spawn ("passmenu"))
        , ("M1-w", spawn ("waldl"))
        , ("M1-e", spawn ("emoji"))
        , ("M1-n", spawn ("notflix"))
        , ("M1-t", spawn ("ytfzf -D"))

    -- KB_GROUP Kill windows
        , ("M-q", kill1)
        , ("M-S-a", killAll)

    -- KB_GROUP Workspaces
        , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)

    -- KB_GROUP Increase/decrease spacing (gaps)
        , ("C-M1-j", decWindowSpacing 4)
        , ("C-M1-k", incWindowSpacing 4)
        , ("C-M1-h", decScreenSpacing 4)
        , ("C-M1-l", incScreenSpacing 4)

    -- KB_GROUP Windows navigation
        , ("M1-m", windows W.focusMaster)
        , ("M-j", windows W.focusDown)
        , ("M-k", windows W.focusUp)
        , ("M-S-m", windows W.swapMaster)
        , ("M-S-j", windows W.swapDown)
        , ("M-S-k", windows W.swapUp)
        , ("M-<Backspace>", promote)
        , ("M-S-<Tab>", rotSlavesDown)
        , ("M-C-<Tab>", rotAllDown)

    -- KB_GROUP Layouts
        , ("M-<Tab>",sendMessage NextLayout)
        , ("M-f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)

    -- KB_GROUP Increase/decrease windows in the master pane or the stack
        , ("M-S-<Up>", sendMessage (IncMasterN 1))
        , ("M-S-<Down>", sendMessage (IncMasterN (-1)))
        , ("M-C-<Up>", increaseLimit)
        , ("M-C-<Down>", decreaseLimit)

    -- KB_GROUP Window resizing
        , ("M-h", sendMessage Shrink)
        , ("M-l", sendMessage Expand)
        , ("M-M1-j", sendMessage MirrorShrink)
        , ("M-M1-k", sendMessage MirrorExpand)

    -- KB_GROUP Scratchpads
        , ("M-s t", namedScratchpadAction myScratchPads "terminal")
        , ("M-s m", namedScratchpadAction myScratchPads "mocp")
        , ("M-s c", namedScratchpadAction myScratchPads "calculator")

    -- KB_GROUP Multimedia Keys
        , ("<XF86AudioPlay>", spawn "mocp --play")
        , ("<XF86AudioPrev>", spawn "mocp --previous")
        , ("<XF86AudioNext>", spawn "mocp --next")
        , ("<XF86AudioMute>", spawn "amixer set Master toggle")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
        , ("<XF86Search>", spawn "dm-websearch")
        , ("<XF86Mail>", runOrRaise "thunderbird" (resource =? "thunderbird"))
        , ("<XF86Calculator>", runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk"))
        , ("<XF86Eject>", spawn "toggleeject")
        , ("<Print>", spawn "dm-maim")
        ]
    -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))
-- END_KEYS

main :: IO ()
main = do
    xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc"
    xmonad $ ewmh def
        { manageHook         = myManageHook <+> manageDocks
        , handleEventHook    = docksEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP
              { ppOutput = \x -> hPutStrLn xmproc0 x
              , ppCurrent = xmobarColor "#c792ea" "" . wrap "<box type=Bottom width=2 mb=2 color=#82AAFF>" "</box>"
              , ppVisible = xmobarColor "#c792ea" "" . clickable
              , ppHidden = xmobarColor "#c792ea" "" . wrap "<box type=Top width=2 mt=2 color=#82AAFF>" "</box>" . clickable
              , ppHiddenNoWindows = xmobarColor "#c792ea" ""  . clickable
              , ppTitle = xmobarColor "#c792ea" "" . shorten 60
              , ppSep =  "<fc=#c792ea> <fn=1>|</fn> </fc>"
              , ppUrgent = xmobarColor "#c792ea" "" . wrap "!" "!"
              , ppExtras  = [windowCount]
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
              }
        } `additionalKeysP` myKeys
