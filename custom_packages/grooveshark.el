;; Copyright (c) 2012 Thejaswi Puthraya

;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use, copy,
;; modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

(require 'web)

(defgroup grooveshark-mode nil
  "Keybindings to control the songs from emacs"
  :group 'applications)

(defcustom grooveshark-mode-key-prefix "M-g"
  "Minor mode keys prefix."
  :type 'string
  :group 'grooveshark-mode)

(defcustom grooveshark-dotjs-host "localhost"
  "The host name of the server running the dotjs plugin"
  :type 'string
  :group 'grooveshark-mode)

(defcustom grooveshark-dotjs-port 3131
  "The port number of the server running the dotjs plugin"
  :type 'integer
  :group 'grooveshark-mode)

(defcustom grooveshark-dotjs-path "/grooveshark.com.js"
  "The path where the requests have to be made"
  :type 'string
  :group 'grooveshark-mode)

(defun grooveshark-request (data)
  (web-http-post () grooveshark-dotjs-path
		 :host grooveshark-dotjs-host
		 :port grooveshark-dotjs-port
		 :data data
		 :logging nil))

(defun grooveshark-next-song ()
  (interactive)
  (let ((data '(("cmd" . "Grooveshark.next();"))))
    (grooveshark-request data)))

(defun grooveshark-prev-song ()
  (interactive)
  (let ((data '(("cmd" . "Grooveshark.previous();"))))
    (grooveshark-request data)))

(defun grooveshark-toggle-song ()
  (interactive)
  (let ((data '(("cmd" . "Grooveshark.togglePlayPause();"))))
    (grooveshark-request data)))

(defvar grooveshark-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (read-kbd-macro (concat grooveshark-mode-key-prefix " p")) 'grooveshark-toggle-song)
    (define-key map (read-kbd-macro (concat grooveshark-mode-key-prefix " f")) 'grooveshark-next-song)
    (define-key map (read-kbd-macro (concat grooveshark-mode-key-prefix " b")) 'grooveshark-prev-song)
    map))

(define-minor-mode grooveshark-mode
  "Grooveshark minor mode"
  nil
  " Grooveshark"
  grooveshark-mode-map)

(provide 'grooveshark)
