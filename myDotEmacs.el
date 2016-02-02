(windmove-default-keybindings)
(setq windmove-wrap-around t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq inhibit-startup-message t)
(setq gc-cons-threshold 5242880)
(put 'erase-buffer 'disabled nil)
(show-paren-mode t)
(global-set-key "\C-x\C-b" 'buffer-menu)
(setq shell-file-name "/bin/bash")
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)
(global-set-key (kbd "C-.") 'undo)
(setq set-mark-command-repeat-pop t)
(setq scroll-preserve-screen-position t)
(setq frame-title-format (format "%%f - Emacs@%s" (system-name)))
(setq-default line-spacing 0)
(add-hook 'dired-mode-hook
          (lambda ()
            (toggle-truncate-lines 1)))

(setq ns-command-modifier (quote meta))
(setq mac-option-modifier 'meta)
(setq ns-function-modifier 'hyper)

(define-key global-map (kbd "M-k") 'kill-this-buffer)

(require 'wdired)
(add-hook 'dired-mode-hook
          '(lambda ()
             (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
))

(setq dired-listing-switches "-alh")

(defun forward-word+1 ()
  "change forward-word behavior"
  (interactive)
  (forward-word)
  (forward-char))
(global-set-key (kbd "M-f") 'forward-word+1)
(global-set-key (kbd "<M-right>") 'forward-word+1)

(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)
(define-key global-map (kbd "C-o") 'other-window)
(define-key dired-mode-map (kbd "C-o") 'other-window)
(define-key global-map (kbd "M-o") 'other-frame)
(define-key dired-mode-map (kbd "M-o") 'other-frame)

(defun other-window-back ()
  (interactive)
  (other-window -1))
(define-key global-map (kbd "C-S-o") 'other-window-back)
(define-key dired-mode-map (kbd "C-S-o") 'other-window-back)

(defun uniq-lines (beg end)
  "Unique lines in region.
Called from a program, there are two arguments:
BEG and END (region to sort)."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (while (not (eobp))
        (kill-line 1)
        (yank)
        (let ((next-line (point)))
          (while
              (re-search-forward
               (format "^%s" (regexp-quote (car kill-ring))) nil t)
            (replace-match "" nil nil))
          (goto-char next-line))))))

(defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer
          (delq (current-buffer)
                (remove-if-not 'buffer-file-name (buffer-list)))))

(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
(setq skeleton-pair 1)

(global-set-key (kbd "C-h") 'delete-backward-char)

(global-set-key "\M-n" 'forward-paragraph)
(global-set-key "\M-p" 'backward-paragraph)

(setq hippie-expand-try-functions-list
       '(
         try-expand-dabbrev
         try-expand-line
         try-complete-file-name-partially
         try-complete-file-name))
(global-set-key [?\M-/] 'hippie-expand)

(defun duplicate-current-line (&optional n)
  "duplicate current line, make more than 1 copy given a numeric argument"
  (interactive "p")
  (save-excursion
    (let ((nb (or n 1))
	  (current-line (thing-at-point 'line)))
      
      (when (or (= 1 (forward-line 1)) (eq (point) (point-max)))
	(insert "\n"))

      
      (while (> n 0)
	(insert current-line)
	(decf n)))))
(global-set-key (kbd "C-S-d") 'duplicate-current-line)

(define-key isearch-mode-map [(control h)] 'isearch-delete-char)


(fset 'yes-or-no-p 'y-or-n-p)

(setq delete-by-moving-to-trash t)

(defun google-at-point()
  "search word at point on google."
  (interactive)
  (save-excursion
    (let ((str (progn (my-mark-whole-word) (buffer-substring-no-properties (point) (mark)))))
      (browse-url
       (concat "http://google.com/search?q=\"" str "\"")))))
(global-set-key [(f1)]  'google-at-point)

(add-to-list 'load-path "~/.emacs.d/minibuf-isearchDir")
(add-to-list 'load-path "~/.emacs.d/sessionDir")
(require 'minibuf-isearch)
(require 'session)
(add-hook 'after-init-hook 'session-initialize)
(setq history-length 200) 
(setq session-initialize '(de-saveplace session keys menus places)
      session-globals-include '((kill-ring 1000000)             
                                (session-file-alist 1000000 t)  
                                (file-name-history 1000000)))  

(define-key ctl-x-map  "?" 'describe-key)

(setq isearch-lazy-highlight-initial-delay 0)

(setq-default tab-width 4)
(setq default-tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
                      64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))

(defun increment-number-at-point ()
  (interactive)
  (skip-chars-backward "0123456789")
  (or (looking-at "[0123456789]+")
      (error "No number at point"))
  (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))

(defun repeat-command (command)
  "Repeat COMMAND."
 (interactive)
 (let ((repeat-previous-repeated-command  command)
       (last-repeatable-command           'repeat))
   (repeat nil)))

(defun increment-number-at-point-repeat ()
  (interactive)
  (repeat-command 'increment-number-at-point))

(global-set-key (kbd "C-c C-+") 'increment-number-at-point-repeat)

(put 'narrow-to-region 'disabled nil)

(require 'dired-x)
(global-set-key (kbd "<f7>") 'dired-jump)

(global-set-key (kbd "M-s") 'isearch-forward-regexp)

(add-hook 'find-file-hooks 'assume-new-is-modified)
(defun assume-new-is-modified ()
  (when (not (file-exists-p (buffer-file-name)))
    (set-buffer-modified-p t)))

(put 'set-goal-column 'disabled nil)
(transient-mark-mode t)

(setq blink-matching-paren nil)

(defun kill-start-of-line ()
  "kill from point to start of line"
  (interactive)
  (kill-line 0))
(global-set-key (kbd "C-#") 'kill-start-of-line)

(display-time)


(define-key global-map (kbd "C-<") 'end-of-buffer)
(define-key global-map (kbd "C->") 'beginning-of-buffer)


(defun rename-file-and-buffer (new-name)
 "Renames both current buffer and file it's visiting to NEW-NAME." (interactive "sNew name: ")
 (let ((name (buffer-name))
	(filename (buffer-file-name)))
 (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
 (if (get-buffer new-name)
	 (message "A buffer named '%s' already exists!" new-name)
	(progn 	 (rename-file name new-name 1) 	 (rename-buffer new-name) 	 (set-visited-file-name new-name) 	 (set-buffer-modified-p nil)))))) 

(defun move-buffer-file (dir)
 "Moves both current buffer and file it's visiting to DIR." (interactive "DNew directory: ")
 (let* ((name (buffer-name))
	 (filename (buffer-file-name))
	 (dir
	 (if (string-match dir "\\(?:/\\|\\\\)$")
	 (substring dir 0 -1) dir))
	 (newname (concat dir "/" name)))

 (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
 (progn 	(copy-file filename newname 1) 	(delete-file filename) 	(set-visited-file-name newname) 	(set-buffer-modified-p nil) 	t))))

(add-to-list 'load-path "~/.emacs.d/iflipbDir/")
(require 'iflipb)
(global-set-key (kbd "<s-tab>") 'iflipb-next-buffer)
(global-set-key (kbd "<S-s-tab>") 'iflipb-previous-buffer)

(defun null-command ()
  "Do nothing (other than standard command processing such as remembering this was the last command executed)"
  (interactive))

(global-set-key (kbd "C-c t") 'null-command)

(setq-default indent-tab-mode nil)

(defun my-dired-open ()
  "Type '\\[my-dired-open]': open the current line's file."
  (interactive)
  (if (eq major-mode 'dired-mode)
      (let ((fname (dired-get-filename)))
		(call-process-shell-command (concat "open \"" fname "\"")) 
        (message "opening... %s" fname)
)))
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map "z" 'my-dired-open)))

(defun launch-filer-from-current-direcotry ()
  "launch finder from current directory"
  (interactive)
  (shell-command "open ." nil))
(define-key global-map (kbd "C-x f") 'launch-filer-from-current-direcotry)
