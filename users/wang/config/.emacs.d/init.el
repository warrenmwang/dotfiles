(setq inhibit-startup-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(set-face-attribute 'default nil :family "Cousine Nerd Font Mono" :height 120)
(ido-mode 1)
(set-scroll-bar-mode nil)

(setq-default tab-width 4)           ; Display tabs as 4 spaces wide
(setq-default indent-tabs-mode t)    ; Use actual tab characters

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-/") 'comment-or-uncomment-region)

(setq backup-directory-alist '(("." . "~/.emacs_saves")))

;; Disable line wrap in normal and vertical windows
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)

;; NOTE: this doesn't seem to do anything lmao -- Try fixing shell colors
(require 'ansi-color)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

(global-auto-revert-mode 1)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; TODO: keymaps for tabs (new, close, move left/right)
;; TODO: enable automatic inserting closing ) ] } '' might be helpful.

;; TODO: get code folding working.
;; TODO: something is making editing slow on large files maybe
;;    copying and pasting
;;    creating a new line from normal mode via 'o' key.

;; TODO: get html syntax highlighting for strings with prefix comment /* html */ in js
;; TODO: javascript template strings dont have more syntax highlighting. they look like regular strings which is bummer
;; TODO: unable to enter tab characters inside of a multiline template string in vue components?

;; TODO: While we have built in json prettify, it'd be nice if we have built in json minify. that might require plugin/jq external tool.

;; TODO: Try out Magit?

;; ================ Packages START ================

(require 'package)
(package-initialize)
(unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(use-package idea-darkula-theme
	:config
	(load-theme 'idea-darkula t))

(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode)
  (evil-set-undo-system 'undo-redo)

  (evil-set-leader 'normal (kbd "SPC"))

  (evil-define-key 'normal 'global
    (kbd "<leader>w") 'save-buffer
	(kbd "gh") 'evil-first-non-blank
	(kbd "gl") 'evil-end-of-line
	(kbd "<leader>o") 'dired
  )

  (evil-define-key 'visual 'global
	(kbd "gh") 'evil-first-non-blank
	(kbd "gl") 'evil-end-of-line
	(kbd "M-f") 'my-counsel-rg-selection
  )
)

(define-key evil-normal-state-map "gn"
  (lambda () (interactive) (evil-search-word-forward)))

(define-key evil-visual-state-map "gn"
  (lambda
    ()
    (interactive)
	(let ((selection (buffer-substring-no-properties
					  evil-visual-beginning
					  evil-visual-end)))
	  (evil-exit-visual-state)
	  (evil-search selection t t))))

;; Evil Normal Mode -- Jump/Switch to Tabs with M-N
;; M-1 through M-9 to switch tabs, M-0 for last one.
(dotimes (i 9)
  (let ((n (+ i 1)))
    (evil-define-key 'normal 'global
      (kbd (format "M-%d" n))
      `(lambda () (interactive) (tab-bar-select-tab ,n)))))
(evil-define-key 'normal 'global
  (kbd "M-0")
  (lambda () (interactive) (tab-bar-select-tab -1)))

(use-package smex
	:bind (("M-x" . smex)
		   ("M-X" . smex-major-mode-commands)
		   ("C-c C-c M-x" . execute-extended-command)))

(use-package rg
  :config

  (evil-define-key 'normal 'global
    (kbd "<leader>sg") 'rg
  )
  (evil-define-key 'normal rg-mode-map
    (kbd "<leader>l") 'rg-toggle-literal
    (kbd "<leader>i") 'rg-toggle-case
    (kbd "<leader>t") 'rg-toggle-filetype
  )
)

(use-package web-mode
  :mode ("\\.html\\'")
  :config
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-code-indent-offset 4)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-css-colorization t))

(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

(use-package counsel
  :config
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("<leader>sf" . counsel-find-file)
         ("<leader>SPC" . counsel-switch-buffer)
         ("<leader>sg" . counsel-rg)
  )
)  

;; TODO: It works, one kink is that sometimes the full autocompleted word doesn't maintain all the correct capitalizations of characters.
;; Autocomplete
(use-package company
  :hook (prog-mode . company-mode)
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)

  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-y") 'company-complete-selection)

  ;; Disable default keymaps
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "TAB") nil)
  (define-key company-active-map (kbd "<tab>") nil)
)

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (defface my-TODO-face
    '((t :background "#FFFF00" :foreground "#000000"))
    "Face for TODO keywords")
  
  (defface my-FIXME-face
    '((t :background "#FF69B4" :foreground "#000000"))
    "Face for FIXME keywords")
  
  (defface my-NOTE-face
    '((t :background "#1E90FF" :foreground "#FFFFFF"))
    "Face for NOTE keywords")
  
  ;; Remove existing keywords if they exist
  (setq hl-todo-keyword-faces
        (cl-remove-if (lambda (x) (member (car x) '("TODO" "FIXME" "NOTE")))
                      hl-todo-keyword-faces))
  
  (add-to-list 'hl-todo-keyword-faces '("TODO" . my-TODO-face))
  (add-to-list 'hl-todo-keyword-faces '("FIXME" . my-FIXME-face))
  (add-to-list 'hl-todo-keyword-faces '("NOTE" . my-NOTE-face))
)

(use-package evil-mc
  :config
  (global-evil-mc-mode 1)
  (define-key evil-normal-state-map (kbd "C-n") 'evil-mc-make-and-goto-next-match)
  (define-key evil-visual-state-map (kbd "C-n") 'evil-mc-make-and-goto-next-match)
  (define-key evil-normal-state-map (kbd "C-S-n") 'evil-mc-skip-and-goto-next-match)
  (define-key evil-visual-state-map (kbd "C-S-n") 'evil-mc-skip-and-goto-next-match)

  (evil-define-key 'normal evil-mc-key-map (kbd "<escape>") 'evil-mc-undo-all-cursors)
)
;; NOTE: really slow issue?
;; (use-package diff-hl
;;   :config
;;   (global-diff-hl-mode)
;;   (diff-hl-flydiff-mode)
;; )

;; ;; Bind ]c and [c in Evil normal state
;; (with-eval-after-load 'evil
;;   (define-key evil-normal-state-map (kbd "]c") 'diff-hl-next-hunk)
;;   (define-key evil-normal-state-map (kbd "[c") 'diff-hl-previous-hunk)
;; )

;; NOTE: some slowness issue?
;; (use-package git-gutter
;;   :config
;;   (global-git-gutter-mode +1)
;;   (setq git-gutter:update-interval 2)) ; Update every 2 seconds instead of constantly

;; (with-eval-after-load 'evil
;;   (define-key evil-normal-state-map (kbd "]c") 'git-gutter:next-hunk)
;;   (define-key evil-normal-state-map (kbd "[c") 'git-gutter:previous-hunk)

;;   (define-key evil-normal-state-map (kbd "<leader>gp") 'git-gutter:popup-hunk)
;;   (define-key evil-normal-state-map (kbd "<leader>gr") 'git-gutter:revert-hunk)
;; )

;; ================ Packages END ================

;; Custom Functions (commands that can be run in M-x)

(defun my-counsel-rg-selection ()
  "Search for selected text with counsel-rg."
  (interactive)
  (let ((selection (buffer-substring-no-properties
                    (region-beginning)
                    (region-end))))
    (counsel-rg selection)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
