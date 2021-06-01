(defun alm/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(defun alm/connect-to-nextcloud()
  (start-process-shell-command
   "bash" nil "mount ~/nextcloud 1>/dev/null"))

(defun alm/kill-and-close ()
  (interactive)
  "Kill a buffer, and if possible, close it's window."
   (kill-current-buffer)
   (delete-window))

(defun alm/exwm-update-title ()
  (pcase exwm-class-name
    ("Brave-browser" (exwm-workspace-rename-buffer (format "Brave: %s" exwm-title)))))

  ;; When window title updates, use it to set the buffer name
  (add-hook 'exwm-update-title-hook #'alm/exwm-update-title)

(defun alm/set-wallpaper()
  (interactive)
  (start-process-shell-command
   "feh" nil "feh --bg-scale /home/hrothgar32/.lightdm_images/futuristic.jpg"))

(defun alm/lock-screen()
  (interactive)
  (start-process-shell-command)
  "i3lock-fancy" nil "i3lock-fancy")

(defun alm/spotify-toggle()
  (interactive)
  (start-process-shell-command
   "playerctl" nil "playerctl --player=spotify play-pause"))

(defun alm/spotify-previous()
  (interactive)
  (start-process-shell-command
   "playerctl" nil "playerctl --player=spotify previous"))

(defun alm/spotify-next()
  (interactive)
  (start-process-shell-command
   "playerctl" nil "playerctl --player=spotify next"))

(defun alm/exwm-init-hook ()
  (alm/start-panel))

(add-hook 'exwm-update-class-hook #'alm/exwm-update-class)
(add-hook 'exwm-init-hook #'alm/exwm-init-hook)

(use-package exwm
  :config
  (setq exwm-workspace-number 5)


  ;; Key resolution
  (require 'exwm-randr)
  (exwm-randr-enable)
  (start-process-shell-command "xrandr" nil "xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal")

  (alm/set-wallpaper)
  ;; (require 'exwm-systemtray)
  ;; (setq exwm-systemtray-height 32)
  ;; (exwm-systemtray-enable)
  ;; Automatically send the mouse cursor to the selected workspace's display
  (setq exwm-workspace-warp-cursor t)

;; These keys should always pass through to Emacs
(setq exwm-input-prefix-keys
    '(?\C-x
      ?\C-u
      ?\C-h
      ?\M-x
      ?\M-`
      ?\M-&
      ?\M-:
      ?\C-\M-j  ;; Buffer list
      ?\C-\
      ))
;; Adding Space to the exwm-input-prefix
(push ?\x20 exwm-input-prefix-keys)


  (map! :map exwm-mode-map
"C-q" 'exwm-input-send-next-key)

  (setq exwm-input-global-keys
        `(
        ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
        ([?\s-r] . exwm-reset)
        ([?\s-f] . exwm-layout-toggle-fullscreen)

        ;; Move between windows
        ([?\s-h] . windmove-left)
        ([?\s-l] . windmove-right)
        ([?\s-k] . windmove-up)
        ([?\s-j] . windmove-down)
        ([?\s-S] . alm/spotify-toggle)
        ([?\s-A] . alm/spotify-previous)
        ([?\s-D] . alm/spotify-next)
        ([?\s-Q] . alm/kill-and-close)
        ([?\s-X] . alm/lock-screen)


        ;; Launching applications
        ;; ([?\s-d] . (lambda (command)
        ;;         (interactive (list (read-shell-command "$ ")))
        ;;         (start-process-shell-command command nil command)))

        ;; Switch workspace
        ([?\s-w] . exwm-workspace-switch)

        ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
        ,@(mapcar (lambda (i)
                `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,i))))
                (number-sequence 0 9))))
  (exwm-input-set-key (kbd "s-d") 'counsel-linux-app)
  (exwm-enable))

(defun alm/kill-panel()
  (interactive)
  (when alm/polybar-process
    (ignore-errors
      (kill-process alm/polybar-process)))
  (setq alm/polybar-process nil)
  )

(defun alm/start-panel()
  (interactive)
  (setq alm/polybar-process (start-process-shell-command "poly" nil "polybar main")))

;; (defun geci ()
;;   (pcase exwm--selected-input-mode
;;     ('line-mode' )
;;     ('char-mode' )
;;     ))

;; (defun alm/send-polybar-mode-hook ()
;;   (setq szam (geci))
;;   (start-process-shell-command "polybar-msg" nil
;;                                "polybar-msg hook exwm-mode 1"))

;; (add-hook 'exwm-input-input-mode-change-hook #'alm/send-polybar-mode-hook)

(use-package desktop-environment
  :after exwm
  :config (desktop-environment-mode)
  :custom
  (desktop-environment-brightness-small-increment "2%+")
  (desktop-environment-brightness-small-decrement "2%-")
  (desktop-environment-brightness-normal-increment "5%+")
  (desktop-environment-brightness-normal-decrement "5%-"))
