;; Universal .emacs

(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))

(require 'evil)
(require 'key-chord)
(require 'auto-complete)

;; Init

(setq backup-directory-alist `(("." . "~/.saves")))

(auto-complete-mode 1)
(electric-pair-mode 1)
(electric-indent-mode 1)
(centered-cursor-mode 1)
(global-linum-mode 1)
(setq linum-format "%d ")

(defun uif ()
  (interactive)
  (find-file user-init-file))

;; Evil

(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(key-chord-define evil-insert-state-map "kj" 'evil-normal-state)
(key-chord-mode 1)

(evil-mode 1)
(evil-set-initial-state 'term-mode 'emacs)
(evil-set-initial-state 'dired-mode 'emacs)

(defun set-modeline-color (foreground background)
  (set-face-attribute  'mode-line
		       nil
		       :foreground foreground
		       :background background
		       :box '(:line-width 1 :style released-button)))

(defun set-modeline-blue-cyan () (set-modeline-color "blue" "cyan"))
(defun set-modeline-green-blue() (set-modeline-color "green" "blue"))
(defun set-modeline-magenta-blue () (set-modeline-color "magenta" "blue"))
(defun set-modeline-red-blue() (set-modeline-color "red" "blue"))

;; Hooks

(add-hook 'evil-normal-state-entry-hook 'set-modeline-blue-cyan)
(add-hook 'evil-insert-state-entry-hook 'set-modeline-green-blue)
(add-hook 'evil-visual-state-entry-hook 'set-modeline-red-blue)
(add-hook 'evil-emacs-state-entry-hook 'set-modeline-magenta-blue)

(add-hook 'term-mode-hook
	  (lambda () (linum-mode 0)))

(add-hook 'shell-mode-hook
	  (lambda () (linum-mode 0)))

;; Keybindings

(windmove-default-keybindings)

(defun other-window-back ()
  (interactive)
  (other-window -1))

(define-minor-mode windmove-mode
  "Personal minor mode for easier window navigation"
  :lighter " wmm"
  :keymap (let ((map (make-sparse-keymap)))
	    (define-key map (kbd "C-c h") 'windmove-left)
	    (define-key map (kbd "C-c j") 'windmove-down)
	    (define-key map (kbd "C-c k") 'windmove-up)
	    (define-key map (kbd "C-c l") 'windmove-right)
	    (define-key map (kbd "M-p") 'other-window)
	    (define-key map (kbd "M-n") 'other-window-back)
	    map)
  :global t)

(windmove-mode)

(global-set-key (kbd "C-\\") 'other-window)
(global-set-key (kbd "C-c u") 'universal-argument)
(global-set-key (kbd "C-c n") 'linum-mode)
(global-set-key (kbd "C-u") 'evil-scroll-up)
(global-set-key (kbd "C-c k") 'windmove-up)
(global-set-key (kbd "C-c j") 'windmove-down)
(global-set-key (kbd "C-c l") 'windmove-right)
(global-set-key (kbd "C-c h") 'windmove-left)

;; Color

(set-face-attribute  'mode-line
		     nil
		     :foreground "blue"
		     :background "cyan"
		     :box '(:line-width 1 :style released-button))
(set-face-attribute  'mode-line-inactive
		     nil
		     :foreground "gray80"
		     :background "gray25"
		     :box '(:line-width 1 :style released-button))

(set-face-foreground 'font-lock-comment-face "cyan")

;; Misc

(defmacro m-goto-linux (name username hostname)
  `(defun ,(intern name) () (interactive)
	  (find-file ,(format "/%s@%s:" username hostname))))

(defmacro m-goto-windows (name hostname drive)
  `(defun ,(intern name) () (interactive)
	  (find-file ,(format "//%s/%s$" hostname drive))))

;; http://stackoverflow.com/questions/730751/hiding-m-in-emacs
(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
    (aset buffer-display-table ?\^M []))

(defun diff-open ()
  (interactive)
  (progn
    (let ((this-window-name (buffer-file-name (window-buffer))))
      (let ((other-window-name (buffer-file-name (next-window-buffer))))
	(diff this-window-name other-window-name)))
    (other-window 1)))
