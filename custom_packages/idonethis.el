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
  (interactive)
  (compose-mail address subject ("Body" . buffer)))

(defun idonethis-send-git-log ()
  "Helper function to send out git logs of a repository."
  (interactive)
  (require 'magit)
  (with-temp-buffer
    (let ((temp-buffer (current-buffer)))
      (magit-log nil (concat "--since=" since-when))
      (with-current-buffer "*magit-log*"
	(let ((start (lambda ()
		       (save-excursion
			 (goto-char (point-min))
			 (next-line)
			 (point))))
	      (end (point-max)))
	  (append-to-buffer temp-buffer (funcall start) end))))
    (reverse-region (point-min) (point-max))
    (idonethis-send idonethis-address idonethis-subject (current-buffer))))

(provide 'idonethis)
