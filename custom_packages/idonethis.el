;; A simple library to send out mails to idonethis.
;;
;; Disclaimer:
;; This is not an 'official' idonethis library.
;;
;; Copyright (c) 2012, Thejaswi Puthraya
;; All rights reserved.

;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions
;; are met: 

;; Redistributions of source code must retain the above
;; copyright notice, this list of conditions and the following
;; disclaimer.

;; Redistributions in binary form must reproduce the
;; above copyright notice, this list of conditions and the following
;; disclaimer in the documentation and/or other materials provided
;; with the distribution.

;; Neither the name of the author nor the
;; names of its contributors may be used to endorse or promote
;; products derived from this software without specific prior written
;; permission.

;; This software is provided by the copyright holders and
;; contributors "as is" and any express or implied warranties,
;; including, but not limited to, the implied warranties of
;; merchantability and fitness for a particular purpose are
;; disclaimed. In no event shall the copyright holder or contributors
;; be liable for any direct, indirect, incidental, special, exemplary,
;; or consequential damages (including, but not limited to,
;; procurement of substitute goods or services; loss of use, data, or
;; profits; or business interruption) however caused and on any theory
;; of liability, whether in contract, strict liability, or tort
;; (including negligence or otherwise) arising in any way out of the
;; use of this software, even if advised of the possibility of such
;; damage.

(defgroup idonethis nil
  "A small library to send mail to idonethis."
  :group 'applications)

(defcustom idonethis-address ""
  "The idonethis email address to send out the daily log.
Usually something like xyz@team.idonethis.com"
  :group 'idonethis
  :type 'string)

(defcustom idonethis-subject "Today's work"
  "The subject of the email sent out"
  :group 'idonethis
  :type 'string)

;; The command below will work on POSIX systems only
;; Windows users will have to override it.
(defun date-since-when (symbol value)
  (set-default symbol (shell-command-to-string "date -d yesterday +%Y-%m-%d")))

(defcustom since-when nil
  "The date since when to send out the git log.
Not required if not using git or magit."
  :set 'date-since-when
  :group 'idonethis
  :type 'string)

(defun idonethis-send (address subject &optional buffer)
  "A function that opens up a mail buffer addressed to the 'idonethis-adress."
  (interactive "sIdonethis Address:\nsSubject:")
  (compose-mail address subject)
  (when buffer
    (let ((mail-buffer (current-buffer)))
      (goto-char (point-max))
      (with-current-buffer buffer
	(append-to-buffer mail-buffer (point-min) (point-max))))))

(defun idonethis-send-git-log ()
  "Helper function to send out git logs of a repository."
  (interactive)
  (require 'magit)
  (magit-log nil (concat "--since=" since-when))
  (with-temp-buffer
    (let ((temp-buffer (current-buffer)))
      (with-current-buffer "*magit-log*"
	(let ((start (lambda ()
		   (save-excursion
		     (goto-char (point-min))
		     (next-line)
		     (point))))
	      (end (point-max)))
	  (append-to-buffer temp-buffer (funcall start) end)))
      (reverse-region (point-min) (point-max))
      (idonethis-send idonethis-address idonethis-subject temp-buffer))))

(provide 'idonethis)
