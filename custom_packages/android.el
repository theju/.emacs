(require 'android-mode)

(setq android-mode-sdk-dir "/home/theju/reqs/android-sdk-linux")
(setq android-mode-avd "Gingerbread")

;; Add the code below to the build.xml in the
;; android project
;; <target name="run">
;;   <exec executable="adb">
;;     <arg value="shell"/>
;;     <arg value="am"/>
;;     <arg value="start"/>
;;     <arg value="-a"/>
;;     <arg value="android.intent.action.MAIN"/>
;;     <arg value="-n"/>
;;     <arg value="com.example/.MainActivity"/>
;;   </exec>
;; </target>
(android-defun-ant-task "debug install run")

(defconst android-mode-keys
  '(("D" . android-start-ddms)
    ("e" . android-start-emulator)
    ("l" . android-logcat)
    ("C" . android-ant-clean)
    ("c" . android-ant-compile)
    ("d" . android-ant-debug-install-run)
    ("i" . android-ant-install)
    ("r" . android-ant-reinstall)
    ("u" . android-ant-uninstall)))


(provide 'android)
