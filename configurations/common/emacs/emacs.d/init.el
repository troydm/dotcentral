;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Zenburn
(load-theme 'zenburn t)
(defun zenburn-color (name)
  (cdr (assoc (format "zenburn-%s" name) zenburn-default-colors-alist)))

;; Backups
(setq backup-directory-alist '((".*" . "~/.emacs.d/backups/"))
      auto-save-file-name-transforms '((".*" "~/.emacs.d/backups/" t))
      backup-by-copying t)

;; Ivy & Swiper
(require 'ivy)
(require 'swiper)
(require 'counsel)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(define-key ivy-minibuffer-map (kbd "ESC <escape>") (kbd "C-g"))
(define-key counsel-ag-map (kbd "ESC <escape>") (kbd "C-g"))

;; Display Line Numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Highlight Line
(global-hl-line-mode t)  
(set-face-attribute 'hl-line nil :background (zenburn-color "bg-2"))

;; Hide Menu for Non-GUI mode
(unless (display-graphic-p)
   (menu-bar-mode -1))

;; Disable Bell on Quit
(setq ring-bell-function
      (lambda ()
	(unless (memq this-command '(exit-minibuffer close-buffer-or-window minibuffer-keyboard-quit keyboard-quit))
	  (ding))))

;; Undotree
(require 'undo-tree)
(global-undo-tree-mode)

;; Evil
(require 'evil)
(evil-mode t)
(setq evil-esc-delay 0.3)

;; Evil Powerline
(require 'powerline)
(require 'powerline-evil)
(setq powerline-evil-tag-style 'verbose)
(set-face-attribute 'powerline-active0 nil :background "brightblack")
(set-face-attribute 'powerline-active2 nil :background (zenburn-color "bg+1"))
(set-face-attribute 'powerline-inactive2 nil :background (zenburn-color "bg-2"))
(set-face-attribute 'powerline-inactive0 nil :background "black")
(set-face-attribute 'powerline-evil-base-face nil :background "brightblack" :foreground "brightwhite")
(set-face-attribute 'powerline-evil-normal-face nil
		    :background "brightblack" :foreground "brightwhite")
(set-face-attribute 'powerline-evil-insert-face nil
		    :background "brightblack" :foreground (zenburn-color "yellow"))
(set-face-attribute 'powerline-evil-visual-face nil
		    :background (zenburn-color "yellow-2") :foreground "brightblack" :weight 'bold)
(set-face-attribute 'powerline-evil-emacs-face nil
		    :background "brightblack" :foreground (zenburn-color "cyan") :weight 'bold)
(set-face-attribute 'powerline-evil-operator-face nil
		    :background "brightblack" :foreground (zenburn-color "red") :weight 'bold)
(set-face-attribute 'powerline-evil-replace-face nil
		    :background "brightblack" :foreground (zenburn-color "orange") :weight 'bold)
(set-face-attribute 'powerline-evil-motion-face nil
		    :background (zenburn-color "green-1") :foreground "brightwhite")
(defun my-powerline-evil-theme ()
  (interactive)
  (setq-default mode-line-format
		'("%e"
		  (:eval
		   (let* ((active (powerline-selected-window-active))
			  (mode-line (if active 'mode-line 'mode-line-inactive))
			  (face0 (if active 'powerline-active0 'powerline-inactive0))
			  (face1 (if active 'powerline-active1 'powerline-inactive1))
			  (face2 (if active 'powerline-active2 'powerline-inactive2))
			  (evil-face (if evil-mode (powerline-evil-face) 'powerline-evil-normal-face))
			  (separator-left (intern (format "powerline-%s-%s"
							  (powerline-current-separator)
							  (car powerline-default-separator-dir))))
			  (separator-right (intern (format "powerline-%s-%s"
							   (powerline-current-separator)
							   (cdr powerline-default-separator-dir))))
			  (lhs (list
				(if evil-mode
				    (powerline-raw (concat " " (powerline-evil-tag) " ") evil-face)
				  (powerline-raw " NOEVIL " 'powerline-evil-normal-face))
				(funcall separator-left evil-face mode-line)
				(powerline-buffer-id `(mode-line-buffer-id ,mode-line) face1)
				(when (buffer-modified-p)
				  (powerline-raw "" mode-line))
				(when buffer-read-only
				  (powerline-raw "[Read Only]" mode-line))
				(when (and vc-mode buffer-file-name)
				  (let ((backend (vc-backend buffer-file-name)))
				    (if (string= backend "Git")
				      (concat (powerline-raw "[" mode-line 'l)
					      (powerline-raw (format "%s" (car (vc-git-branches))))
					      (powerline-raw "]" mode-line)))))
				(funcall separator-left mode-line face2)))
			  (rhs (list
				(funcall separator-right face2 'powerline-evil-insert-face)
				(powerline-major-mode 'powerline-evil-insert-face)
				(funcall separator-right 'powerline-evil-insert-face mode-line)
				(powerline-raw "%l/" mode-line 'l)
				(powerline-raw (format-mode-line '(10 "%c")))
				(powerline-raw (replace-regexp-in-string  "%" "%%" (format-mode-line '(-3 "%p"))) mode-line 'r))))
		     (concat (powerline-render lhs)
			     (powerline-fill face2 (powerline-width rhs))
			     (powerline-render rhs)))))))
(my-powerline-evil-theme)

;; Window Navigation
(defun my-window-right ()
  (interactive)
  (condition-case nil (evil-window-right 1)
    (error (evil-window-left 1))))
(defun my-window-left ()
  (interactive)
  (condition-case nil (evil-window-left 1)
    (error (evil-window-right 1))))
(defun my-window-up ()
  (interactive)
  (condition-case nil (evil-window-up 1)
    (error (evil-window-down 1))))
(defun my-window-down ()
  (interactive)
  (condition-case nil (evil-window-down 1)
    (error (evil-window-up 1))))

(global-set-key (kbd "M-<left>") #'my-window-left)
(global-set-key (kbd "M-<right>") #'my-window-right)
(global-set-key (kbd "M-<up>") #'my-window-up)
(global-set-key (kbd "M-<down>") #'my-window-down)
(global-set-key (kbd "M-h") #'my-window-left)
(global-set-key (kbd "M-l") #'my-window-right)
(global-set-key (kbd "M-k") #'my-window-up)
(global-set-key (kbd "M-j") #'my-window-down)
(global-set-key (kbd "ESC <left>") #'my-window-left)
(global-set-key (kbd "ESC <right>") #'my-window-right)
(global-set-key (kbd "ESC <up>") #'my-window-up)
(global-set-key (kbd "ESC <down>") #'my-window-down)
(global-set-key (kbd "ESC h") #'my-window-left)
(global-set-key (kbd "ESC l") #'my-window-right)
(global-set-key (kbd "ESC k") #'my-window-up)
(global-set-key (kbd "ESC j") #'my-window-down)

;; Close Buffer/Window
(defun close-buffer-or-window ()
  (interactive)
  (if (or (minibufferp) (buffer-file-name) (= (length (window-list)) 1))
      (kill-this-buffer)
    (delete-window)))
(global-set-key (kbd "C-q") #'close-buffer-or-window)

;; Convenient Global Keybindings
(global-set-key (kbd "M-x") #'counsel-M-x)
(global-set-key (kbd "C-s") #'save-buffer)
(global-set-key (kbd "C-x C-f") #'counsel-find-file)
(global-set-key (kbd "C-x x") #'delete-window)
(global-set-key (kbd "C-x -") #'split-window-vertically)
(global-set-key (kbd "C-x |") #'split-window-horizontally)

;; Convenient Evil Keybindings
(define-key evil-normal-state-map (kbd "C-f") nil)
(define-key evil-normal-state-map (kbd "C-f") #'counsel-find-file)
(define-key evil-normal-state-map (kbd "C-g") #'counsel-ack)
(define-key evil-normal-state-map (kbd "M-/") #'swiper)
(define-key evil-normal-state-map (kbd "\\") nil)
(define-key evil-normal-state-map (kbd "\\e") #'eval-last-sexp)
(define-key evil-normal-state-map (kbd "\\b") #'ivy-switch-buffer)
(define-key evil-normal-state-map (kbd "\\t") #'neotree)
(define-key evil-normal-state-map (kbd "\\u") #'undo-tree-visualize)
(define-key evil-emacs-state-map (kbd "M-/") #'swiper)

;; Neotree
(add-to-list 'load-path "~/.emacs.d/elpa/neotree-20200324.1946")
(require 'neotree)
(evil-set-initial-state 'neotree-mode 'emacs)
(set-face-attribute 'neo-root-dir-face nil :foreground (zenburn-color "red"))
(set-face-attribute 'neo-expand-btn-face nil :foreground "brightwhite" :weight 'bold)
(set-face-attribute 'neo-dir-link-face nil :foreground (zenburn-color "yellow") :weight 'bold)

;; Slime
(setq inferior-lisp-program "ros run --")
(add-to-list 'slime-contribs 'slime-repl)

;; Custom Set Variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-undo-system 'undo-tree)
 '(package-selected-packages
   '(undo-tree lispy magit zenburn-theme slime powerline-evil pfuture hydra ht f counsel cfrs ace-window)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
