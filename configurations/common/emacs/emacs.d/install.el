;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-refresh-contents)

(defun install-packages (&rest packages)
  "Install Packages"
  (mapcar (lambda (package)
            (unless (package-installed-p package)
	      (message (format "Installing %s package" package))
	      (package-install package))) packages))

(install-packages 'zenburn-theme 'undo-tree 'counsel 'powerline-evil 'magit 'company 'eros 'slime 'slime-company 'lispy)
(package-initialize)

(shell-command "git clone https://github.com/troydm/emacs-neotree.git ~/.emacs.d/elpa/neotree-20200324.1946")
(byte-recompile-directory "~/.emacs.d/elpa/neotree-20200324.1946/")
