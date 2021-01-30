;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)

(defun install-packages (&rest packages)
  "Install Packages"
  (mapcar (lambda (package)
            (unless (package-installed-p package)
	      (message (format "Installing %s package" package))
	      (package-install package))) packages))

(install-packages 'zenburn-theme 'counsel 'powerline-evil 'treemacs 'treemacs-evil 'slime)
