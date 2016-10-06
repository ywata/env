;;; init.el --- Emacs configuration. -*- lexical-binding: t -*-
;;
;; Author: Anler Hp <inbox@anler.me>
;; URL: https://gihub.com/anler/.emacs.d
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation; either version 3 of the License, or (at your option) any later
;; version.

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.

;; You should have received a copy of the GNU General Public License along with
;; GNU Emacs; see the file COPYING.  If not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
;; USA.

;;; Commentary:

;; Emacs configuration of Yasu based on Anler Hp's configuration.

;;
(setq backup-inhibited t)
(define-key global-map "\C-h" 'delete-backward-char)
(define-key global-map "\C-j" 'scroll-down)
(define-key global-map "\C-o" 'scroll-down)

(define-prefix-command 'ctl-Q-keymap)
(global-set-key (kbd "C-q") 'ctl-Q-keymap)
(define-key ctl-Q-keymap (kbd "\C-d") 'view-window-mode)
					;(define-key ctl-Q-keymap (kbd "\C-e") 'eval-last-sexp)
(define-key ctl-Q-keymap (kbd "\C-e") 'next-error)
(define-key ctl-Q-keymap (kbd "\C-n") 'view-window-next-buffer)
(define-key ctl-Q-keymap (kbd "\C-p") 'view-window-prev-buffer)
(define-key ctl-Q-keymap (kbd "\C-w") 'whitespace-mode)




;;; Code:
(require 'package)

(setq package-enable-at-startup nil
      package-archives '(
                         ("elpa" . "http://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
;;                         ("melpa-stable" . "http://stable.melpa.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         )
      )

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


(require 'use-package)

;(load "~/.emacs.d/site-lisp/view-window.el")
(use-package view-window
  :load-path "~/.emacs.d/site-lisp/view-window.el"
  :demand t)


(use-package whitespace
	     :load-path "~/.emacs.d/site-lisp"
	     :demand t)

(use-package benchmark-init
  :ensure t
  :config (benchmark-init/activate))


(use-package paren
  :defer t
  :init
  (add-hook 'emacs-lisp-mode-hook 'show-paren-mode)
  (add-hook 'haskell-mode-hook 'show-paren-mode)
  (add-hook 'sgml-mode-hook 'show-paren-mode))

(use-package elec-pair
  :defer t
  :init
  (add-hook 'emacs-lisp-mode-hook 'electric-pair-mode)
  (add-hook 'css-mode-hook 'electric-pair-mode)
  (add-hook 'haskell-mode-hook 'electric-pair-mode))


(use-package multiple-cursors
  :ensure t
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-M->" . mc/skip-to-next-like-this)
         ("C-M-<" . mc/skip-to-previous-like-this)
         ("C-S-c C-S-c" . mc/edit-lines)
         ("C-M-0" . mc/mark-all-like-this)
         ("M-<down-mouse-1>" . mc/add-cursor-on-click)))


(use-package haskell-mode
  :ensure t
  :mode "\\.hs\\'"
  :bind (:map haskell-mode-map
              ("C-,"     . haskell-move-nested-left)
              ("C-."     . haskell-move-nested-right)
              ("C-c C-." . haskell-mode-format-imports)

              ("s-i"     . haskell-navigate-imports)

              ("C-c C-l" . haskell-process-load-or-reload)
              ("C-`"     . haskell-interactive-bring)
              ("C-c C-t" . haskell-process-do-type)
              ("C-c C-i" . haskell-process-do-info)
              ("C-c C-c" . haskell-process-cabal-build)
              ("C-c C-k" . haskell-interactive-mode-clear)
              ("C-c c"   . haskell-process-cabal))
  :init
  (add-hook 'haskell-mode-hook 'haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
;  (add-hook 'haskell-mode-hook (defun haskell-project-mode ()
;                                 (interactive)
;                                 (when (projectile-project-p)
;                                   (intero-mode)
;                                   (flycheck-mode))))

  :config
  (defun haskell-mode-before-save-handler ()
    "Function that will be called before buffer's saving."
    (when (projectile-project-p)
      (haskell-sort-imports)
      (haskell-mode-stylish-buffer))))


(use-package intero
  :ensure t
  :defer t)

