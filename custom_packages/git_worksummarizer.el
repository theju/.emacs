(require 'magit)

(defun send-log-idonethis ()
  (interactive)
  (compose-mail "agiliq@team.idonethis.com" "Today's work")
  (let ((yesterday (shell-command-to-string "date -d yesterday +%Y-%m-%d"))
	(mail-buffer (current-buffer))
	(summary-buffer-name "*summary*"))
    (magit-log nil (concat "--since=" yesterday))
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

(provide 'git_worksummarizer)
