(require 'cl)

(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/"))
(require 'package)
(dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
                  ("elpa" . "http://tromey.com/elpa/")
		  ("gnu" . "http://elpa.gnu.org/")))
  (add-to-list 'package-archives source t))
(package-initialize)

(setq tags-file-name "~/TAGS")
(global-set-key (kbd "<f5>") 'find-tag)
(global-set-key (kbd "<f6>") 'rgrep)
(global-set-key (kbd "<f7>") 'magit-status)

(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)

(require 'multi-term)
(setq multi-term-program "/bin/bash")
(multi-term)
(defalias 'term 'multi-term)

(defun build-tags (tag-path) 
  (interactive "DTag Library Path: ")
  (call-process-shell-command 
   (concat "find " tag-path " -name '*.py' -print |xargs etags -o ~/TAGS") 
   nil 
   (get-buffer-create "Etags Compile") 
   1)
)
(defalias 'etb 'build-tags)

(defalias 'yes-or-no-p 'y-or-n-p)

(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "epylint" (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init))
  (defun flymake-display-err-message-for-current-line ()
    "Display a menu with errors/warnings for current line if it has errors and/or warnings."
    (interactive)
    (let* ((line-no             (flymake-current-line-no))
  	   (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
  	   (menu-data           (flymake-make-err-menu-data line-no line-err-info-list))
  	   (choice              nil))
      (if menu-data
  	  (message (car (nth 0 (nth 1 menu-data)))))))
  (defun flymake-display-next-error ()
    (interactive)
    (flymake-goto-next-error)
    (message (flymake-display-err-message-for-current-line)))
  (global-set-key (kbd "<f8>") 'flymake-display-next-error)
  (defun flymake-display-prev-error ()
    (interactive)
    (flymake-goto-prev-error)
    (message (flymake-display-err-message-for-current-line)))
  (global-set-key (kbd "<f9>") 'flymake-display-prev-error)
  (add-hook 'python-mode-hook 'flymake-mode))

(require 'django-macros)
(require 'pomodoro)
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (require 'color-theme-solarized)
     (color-theme-solarized-dark)
     ))

(custom-set-variables
 '(flymake-gui-warnings-enabled nil)
 '(flymake-start-syntax-check-on-newline t)
 '(gud-tooltip-echo-area t)
 '(python-check-command "epylint --stdlib")
 '(python-python-command "ipython")
 '(tags-case-fold-search nil)
 '(tooltip-use-echo-area t)
 '(inhibit-splash-screen t)
 '(transient-mark-mode t)
 '(ido-mode t)
 '(icomplete-mode t)
 '(column-number-mode t)
 '(menu-bar-mode nil)
 '(diff-switches "-u")
 '(require-final-newline 'query)
)
