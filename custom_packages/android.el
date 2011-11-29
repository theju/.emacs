(require 'android-mode)

(setq android-mode-sdk-dir "/home/theju/reqs/android-sdk-linux")
(setq android-mode-avd "Froyo")

(android-defun-ant-task "debug install")

(defconst android-mode-keys
  '(("D" . android-start-ddms)
    ("e" . android-start-emulator)
    ("l" . android-logcat)
    ("C" . android-ant-clean)
    ("c" . android-ant-compile)
    ("d" . android-ant-debug\ install)
    ("i" . android-ant-install)
    ("r" . android-ant-reinstall)
    ("u" . android-ant-uninstall)))


(provide 'android)
