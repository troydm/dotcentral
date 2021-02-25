;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Dmitry Geurkov"
      user-mail-address "d.geurkov@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "DejaVuSansMono Nerd Font Mono" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-zenburn)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Window Movement
(defun my-window-right()
  (interactive)
  (condition-case nil (evil-window-right 1)
    (error (evil-window-left 1))))
(defun my-window-left()
  (interactive)
  (condition-case nil (evil-window-left 1)
    (error (evil-window-right 1))))
(defun my-window-up()
  (interactive)
  (condition-case nil (evil-window-up 1)
    (error (evil-window-down 1))))
(defun my-window-down()
  (interactive)
  (condition-case nil (evil-window-down 1)
    (error (evil-window-up 1))))
(map! :nve "M-h" #'my-window-left
      :nve "M-k" #'my-window-up
      :nve "M-j" #'my-window-down
      :nve "M-l" #'my-window-right
      :nve "M-<left>" #'my-window-left
      :nve "M-<up>" #'my-window-up
      :nve "M-<down>" #'my-window-down
      :nve "M-<right>" #'my-window-right
      :nve "ESC <left>" #'my-window-left
      :nve "ESC <up>" #'my-window-up
      :nve "ESC <down>" #'my-window-down
      :nve "ESC <right>" #'my-window-right)

;; Close Buffer or Window
(map! :nve "C-q" (cmd! (if (buffer-file-name)
                           (kill-current-buffer)
                           (+workspace/close-window-or-workspace))))

;; Configure Neotree
;; (add-hook 'window-setup-hook (lambda () (interactive) (neotree)))
;; (setq-hook! neotree-mode-hook neo-show-updir-line t)
;;(setq neo-show-updir-line t)

;; Fullscreen and Maximize Window
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Convenient Key Bindings
(map! :nve "\\t" #'neotree
      :nve "\\e" "C-x C-e"
      :nve "C-f" #'counsel-find-file
      :nve "C-s" #'save-buffer)

;; Customize Zenburn
(setq-default doom-zenburn-brighter-comments nil
              doom-zenburn-brighter-modeline t)
(custom-theme-set-faces! 'doom-zenburn
  `(mode-line :background ,(doom-color 'base1) :foreground ,(doom-color 'fg))
  `(mode-line-inactive :background ,(doom-color 'base0) :foreground ,(doom-color 'fg-1))
  `(mode-line-emphasis :foreground ,(doom-color 'base8)))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
