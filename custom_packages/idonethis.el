(require 'magit)

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
(defcustom since-when (shell-command-to-string "date -d yesterday +%Y-%m-%d")
  "The date since when to send out the log"
  :group 'idonethis
  :type 'string)

(defcustom summary-buffer "*summary*"
  "The name of the temporary summary buffer generated.
Shouldn't be required for customization since it is killed at
the end of the log generation."
  :group 'idonethis
  :type 'string)

(defun idonethis-send-log ()
  (interactive)
  (compose-mail idonethis-address idonethis-subject)
  (let ((since-date since-when)
	(mail-buffer (current-buffer))
	(summary-buffer-name summary-buffer))
    (magit-log nil (concat "--since=" since-date))
    (with-current-buffer "*magit-log*"
      (let ((start (lambda ()
		     (save-excursion
		       (goto-char (point-min))
		       (next-line)
		       (point))))
	    (end (point-max))
	    (summary-buffer (get-buffer-create summary-buffer-name)))
	(append-to-buffer summary-buffer (funcall start) end)))
    (with-current-buffer summary-buffer-name
      (reverse-region (point-min) (point-max))
      (append-to-buffer mail-buffer (point-min) (point-max)))
    (with-current-buffer mail-buffer
      (smtpmail-send-it))
    (kill-buffer (get-buffer summary-buffer-name))))

(provide 'idonethis)
