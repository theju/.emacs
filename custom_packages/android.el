(require 'android-mode)

(setq compilation-environment '("PATH=/home/theju/reqs/apache-ant-1.8.2/bin:/home/theju/reqs/android-sdk-linux/platform-tools:/home/theju/reqs/android-sdk-linux/tools:/home/theju/reqs/jdk1.7.0_01/bin:/home/theju/reqs/apache-ant-1.8.2/bin:/home/theju/reqs/android-sdk-linux/platform-tools:/home/theju/reqs/android-sdk-linux/tools:/home/theju/reqs/jdk1.7.0_01/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"))

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
