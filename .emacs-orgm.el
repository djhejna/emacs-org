;; -*- mode: Emacs-Lisp; fill-column: 75; comment-column: 50; -*-
;; The following lines are always needed.  Choose your own keys.
(require 'org)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-switchb)

(setq org-use-speed-commands t) ; ? speed-key opens Speed Keys help
(setq org-speed-commands-user
 '(("Scheduling Commands (custom djh)")
   ("d" . org-deadline)
   ("S" . org-schedule)
   )
 )


;; (with-eval-after-load 'org ;; better practice to rely on (require 'org)
;;   (progn
;;     (define-key org-mode-map (kbd "") 'org-)
;;     )
;;   )
(define-key org-mode-map (kbd "<f5>") 'org-refile)
(define-key org-mode-map (kbd "<f6>") 'org-refile-goto-last-stored)
(defun my/org-jump-using-refile-interface ()
  (interactive)
  (let ((current-prefix-arg '(4))) ; C-u
    (call-interactively 'org-refile)))
(define-key org-mode-map (kbd "<f7>") 'my/org-jump-using-refile-interface)

		    
(set-face-attribute 'org-headline-done nil :strike-through t)

(setq org-catch-invisible-edits 'show-and-error)  ; do me
(setq org-refile-targets '((nil :maxlevel . 9)))  ; do me
(setq org-refile-use-outline-path 'file)          ; do me
(setq org-refile-use-cache 't)                    ; do me
(require 'org-habit)


(setq org-agenda-files
      (list
       "/home/djhejna/Documents/2018.org"
	;; "c:/Users/d/Documents/2018.org"
	;; "c:/Users/d/Documents/djhejna/shorttermTODOs.org"
	    )	    
      ;; "~/org/work.org"
      ;; "~/org/school.org" 
      ;; "~/org/home.org"
      )

;;; from: https://orgmode.org/worg/org-tutorials/org-custom-agenda-commands.html (with customizations)
(setq org-agenda-custom-commands
      '(("p" . "Filter on Priorities...")
	("pa" "A items" tags-todo "+PRIORITY={A}") ;; important things to do
	("pb" "B items" tags-todo "+PRIORITY={B}") ;; important things to do
	("pc" "C items" tags-todo "+PRIORITY={C}") ;; important things to do
	("P" "TODOs Grouped by Priority"
	 (
	  (tags-todo "+PRIORITY={A}") ;; important things to do
	  (tags-todo "+PRIORITY={B}") ;; medium important things to do
	  (tags-todo "+PRIORITY={C}") ;; other things to do
	  ))
	))

;;; Agenga: show 7 days starting from today and last 3 days
(setq org-agenda-span 10
      org-agenda-start-on-weekday nil
      org-agenda-start-day "-3d")

(defun org-todo-with-date (&optional arg)
  (interactive "P")
  (cl-letf* ((org-read-date-prefer-future nil)
             (my-current-time (org-read-date t t nil "when:" nil nil nil))
            ((symbol-function #'org-current-effective-time)
             #'(lambda () my-current-time)))
    (org-todo arg)
    )) 


;;; from:  https://stackoverflow.com/questions/21113907/agenda-view-in-orgmode-sorted-by-tag
;; priority levels
;; (add-to-list 'org-agenda-custom-commands
;;              '("p" . "Priorities...") t)


;; (add-to-list 'org-agenda-custom-commands
;;              '("pa" "Actions Grouped by Priority"
;;                (;; important things to do
;;                 (tags-todo "+PRIORITY={A}")
;;                 ;; medium important things to do
;;                 (tags-todo "+PRIORITY={B}")
;;                 ;; other things to do
;;                 (tags-todo "+PRIORITY={C}"))) t)




;;; (custom-theme-set-faces
;;;  'user
;;;  '(org-block                 ((t (:inherit fixed-pitch))))
;;;  '(org-document-info         ((t (:foreground "dark orange"))))
;;;  '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
;;;  '(org-link                  ((t (:foreground "royal blue" :underline t))))
;;;  '(org-meta-line             ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;;;  '(org-property-value        ((t (:inherit fixed-pitch))) t)
;;;  '(org-special-keyword       ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;;;  '(org-tag                   ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
;;;  '(org-verbatim              ((t (:inherit (shadow fixed-pitch))))))


;;; for exporting agenda-views
;;; (setq htmlize-face-overrides
;;;       ’(font-lock-warning-face "black"
;;;         font-lock-function-name-face "red"
;;;         font-lock-comment-face "blue"
;;;         default (:foreground "dark-green" :background "yellow")))

(setq htmlize-face-overrides
     '(
       default (:background "ivory4")))

(setq htmlize-face-overrides
     '(
       default (:background "burlywood4")))


(setq htmlize-face-overrides
     '(
       ;;default (:foreground "green" :background "gray33")))
       default (:foreground "green" :background "black")))

;;;(setq org-priority-faces '((?A . (:foreground "yellow" :weight 'bold))
;;;                           (?B . (:foreground "gray"))
;;;                           (?C . (:foreground "slategray"))))
(setq org-priority-faces '((?A . (:foreground "yellow"))
                           (?B . (:foreground "gray"))
                           (?C . (:foreground "slategray"))))
;; (setq org-todo-keyword-faces
;;       '(
;; 	;;("TODO" . org-warning)
;; 	("TODO" . "red")
;; 	("STARTED" . "yellow")	
;;         ("WAITING" . (:foreground "blue" :weight bold))))


;;; (Setq htmlize-face-overrides
;;;       '(font-lock-warning-face "black"
;;;         font-lock-function-name-face "red"
;;;         font-lock-comment-face "blue"
;;;         default (:foreground "dark-green" :background "yellow")))

;;; (custom-theme-set-faces
;;;  'user
;;;  '(org-block                 ((t (:inherit fixed-pitch))))
;;;  '(org-document-info         ((t (:foreground "dark orange"))))
;;;  '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
;;;  '(org-link                  ((t (:foreground "royal blue" :underline t))))
;;;  '(org-meta-line             ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;;;  '(org-property-value        ((t (:inherit fixed-pitch))) t)
;;;  '(org-special-keyword       ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;;;  '(org-tag                   ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
;;;  '(org-verbatim              ((t (:inherit (shadow fixed-pitch))))))
