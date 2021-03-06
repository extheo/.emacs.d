;;; core-completion.el --- Completion settings -*- lexical-binding: t; -*-

;;; Ivy

(use-package ivy
  :demand
  :bind (:map ivy-minibuffer-map
              ("C-j" . ivy-immediate-done)
              ("RET" . ivy-alt-done))
  :config
  (setq ivy-count-format "(%d/%d) "
        ivy-fixed-height-minibuffer t
        ;; Highlight whole line.
        ivy-format-function #'ivy-format-function-line
        ivy-height 10
        ;; No ^ initially.
        ivy-initial-inputs-alist nil
        ivy-magic-slash-non-match-action nil
        ;; Use current prompt as a candidate.
        ivy-use-selectable-prompt t
        ivy-use-virtual-buffers 'bookmarks
        ivy-wrap t)
  (ivy-set-actions t '(("y" kill-new "yank")))
  (ivy-mode 1))

(use-package ivy-hydra
  :demand :after ivy
  :config
  (setq ivy-read-action-function #'ivy-hydra-read-action))

(use-package counsel
  :config
  (setq counsel-find-file-ignore-regexp
        (concat
         ;; File names beginning with `#` or `.`.
         "\\(?:\\`[#.]\\)"
         ;; File names ending with `#` or `~`.
         "\\|\\(?:\\`.+?[#~]\\'\\)")))

;; Prioritize most recent choices.
(use-package prescient
  :config
  (prescient-persist-mode))

(use-package ivy-prescient
  ;; Should be loaded after counsel according to the docs.
  :demand :after counsel
  :config
  (setq ivy-prescient-sort-commands
        '(:not swiper swiper-isearch
               ivy-switch-buffer
               counsel-imenu counsel-outline
               counsel-recentf
               ivy-bibtex))
  (ivy-prescient-mode))

(use-package swiper)

(use-package ivy-posframe
  :demand :if window-system
  :disabled ;; TODO: breaks ivy-read-action-function
  :config
  (setq ivy-posframe-display-functions-alist
        '((counsel-company . ivy-posframe-display-at-point)))
  (setq ivy-posframe-border-width 2
        ivy-posframe-width 50
        ivy-posframe-min-width 50)
  (ivy-posframe-mode))

(use-package wgrep
  :config
  (setq wgrep-auto-save-buffer t))

;;; Avy

(use-package avy)

;;; Company

(use-package company
  :demand
  :commands company-complete-common
  :config
  ;; (company-tng-mode +1) is set up by evil-collection.
  (setq company-backends '(company-files company-capf)
        company-idle-delay 0.25
        company-selection-wrap-around t
        company-show-numbers t
        company-tooltip-align-annotations t
        company-tooltip-width-grow-only t)
  (global-company-mode 1)
  (general-define-key
   :keymaps 'company-active-map
   "C-/" #'company-filter-candidates
   "C-?" #'counsel-company) ;; FIXME find a better binding?
  (general-define-key
   :keymaps 'company-search-map
   "C-n" #'company-select-next-or-abort
   "C-p" #'company-select-previous-or-abort)
  (dotimes (i 10)
    (general-define-key
     :keymaps '(company-active-map company-search-map)
     (format "C-%d" i) #'company-complete-number)))

(use-package company-prescient
  :hook (company-mode . company-prescient-mode))

;;; Yasnippet

(use-package yasnippet)

(provide 'core-completion)
;;; core-completion.el ends here
