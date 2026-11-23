(use-package org-journal
  :ensure t
  :bind (("C-c j" . org-journal-new-entry))
  :custom
  ;; 1. Storage & Grouping (Use forward slashes even on Windows)
  ;;(org-journal-dir "~/org/journal/")
  (org-journal-dir "c:/Users/d/OneDrive/Documents/org/journal/")
  (org-journal-file-type 'monthly) ; Options: 'daily, 'weekly, 'monthly, 'yearly
  (org-journal-file-format "%Y-%m.org")

  ;; 2. Formatting for Reflection
  (org-journal-date-format "%A, %B %d, %Y") ; e.g., Saturday, November 07, 2026
  (org-journal-time-format "%I:%M %p ")     ; e.g., 06:26 PM 

  ;; 3. Keep Diary Separate from TODOs
  (org-journal-enable-agenda-integration nil)
  (org-journal-carryover-items nil)

  ;; 4. Optional Privacy (Uncomment lines below if you have Gpg4win installed)
  ;; (org-journal-enable-encryption t)
  ;; (org-journal-encrypt-journal t)
  )
