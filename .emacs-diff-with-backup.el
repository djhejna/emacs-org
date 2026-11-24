;; ✅ How this function works
;; buffer-file-name retrieves the path of the file you are currently visiting.
;; Emacs’s auto-save/backup convention uses the form #filename# in the same directory.
;; The function constructs that backup filename using:
;; file-name-directory
;; file-name-nondirectory
;; format to wrap the name in #...#
;; It checks whether the backup exists with file-exists-p.
;; If found, it launches ediff-files, opening a visual diff session between:
;; the current file
;; the backup file
;; ✅ Usage
;; Open any file in Emacs, then run:
;; M-x my-ediff-backup
;; If a #filename# backup exists, you’ll get an Ediff session showing differences.

(defun my-ediff-backup ()
  "Compare the current file with its Emacs backup file #filename# using ediff."
  (interactive)
  (unless buffer-file-name
    (error "This buffer is not visiting a file"))
  (let* ((file buffer-file-name)
         (dir  (file-name-directory file))
         (base (file-name-nondirectory file))
         (backup (expand-file-name (format "#%s#" base) dir)))
    (unless (file-exists-p backup)
      (error "Backup file not found: %s" backup))
    (ediff-files file backup)))


;; ✅ Variation: Compare with numbered backups (filename.~1~)
;; If you want to compare with Emacs’s numbered backups instead of auto-save files:

(defun my-ediff-numbered-backup ()
  "Compare current file with its most recent numbered backup using ediff."
  (interactive)
  (unless buffer-file-name
    (error "This buffer is not visiting a file"))
  (let* ((file buffer-file-name)
         (backups (file-backup-file-names file)))
    (unless backups
      (error "No numbered backups found for %s" file))
    (ediff-files file (car backups))))


;; This uses file-backup-file-names, which returns a list of all numbered backups, newest first.
;; ✅ Variation: Prompt for which backup to compare


(defun my-ediff-choose-backup ()
  "Prompt for any backup file of the current file and compare using ediff."
  (interactive)
  (unless buffer-file-name
    (error "This buffer is not visiting a file"))
  (let* ((file buffer-file-name)
         (backups (file-backup-file-names file))
         (choice (completing-read "Choose backup: " backups nil t)))
    (ediff-files file choice)))


;; ✅ Practical considerations
;; Auto-save files (#file#) are created only when Emacs auto-saves; they may not exist if you saved manually.
;; Backup files (file.~1~) require backup-by-copying or similar settings.
;; Ediff sessions create control buffers; quitting with q cleans them up.
;; You can bind the function to a key, e.g.:
(global-set-key (kbd "C-c e b") #'my-ediff-backup)



;; The simplest solution is to use file-backup-file-names to gather all backup files for a target filename and then loop over them calling ediff-files for each comparison.
;; ✅ Core idea
;; Emacs already provides a built‑in function:
;; file-backup-file-names returns all backup files for a given filename, sorted newest first 
;; 1
;; .
;; This avoids manually scanning directories or filtering with regexes.

;; 1 Source
;; ✅ Full working command
;; This command compares each backup file with the current file using ediff-files.

(defun compare-all-backups (filename)
  "Compare FILENAME with all its backup files using ediff."
  (interactive "fFile to compare with backups: ")
  (let ((backups (file-backup-file-names filename)))  ;; built-in [^3^]
    (if (null backups)
        (message "No backup files found for %s" filename)
      (dolist (backup backups)
        (ediff-files filename backup)))))
;; ✅ How it works
;; file-backup-file-names returns all backup names for filename
;; 1
;;  .
;; The command loops through each backup and launches ediff-files.
;; Backups are sorted newest → oldest, so comparisons start with the most recent.

;; 1 Source
;; ✅ Variant: Compare autosave files (#filename#) in a directory
;; Autosave files are not included in file-backup-file-names, so you can use directory-files (recommended by StackOverflow for platform‑independent directory scanning 
;; Stack Overflow
;; ):
(defun compare-autosaves-in-dir (dir filename)
  "Compare FILENAME with all autosave files (#FILENAME#) in DIR."
  (interactive "DDirectory: 
fFile to compare: ")
  (let* ((base (file-name-nondirectory filename))
         (pattern (format "#%s#" base))
         (autosaves (directory-files dir t pattern))) ;; platform-independent [^5^]
    (if (null autosaves)
        (message "No autosave files matching %s in %s" pattern dir)
      (dolist (auto autosaves)
        (ediff-files filename auto)))))

;; ✅ Variant: Interactive selection of backup to compare
(defun compare-backup-choose (filename)
  "Interactively choose a backup file to compare with FILENAME."
  (interactive "fFile: ")
  (let ((backups (file-backup-file-names filename)))  ;; built-in [^3^]
    (if (null backups)
        (message "No backups found.")
      (let ((choice (completing-read "Choose backup: " backups)))
        (ediff-files filename choice)))))

;; ✅ When to use which
;; Goal				Best function
;; ------------------------------  -------------------------
;; Compare all backups		compare-all-backups
;; Compare autosave files		compare-autosaves-in-dir
;; Choose a backup interactively	compare-backup-choose



;;;;  These from first search results

(defun my-compare-with-backup ()
  "Compare the current file with its most recent backup using ediff-files."
  (interactive)
  (let ((buf-file (buffer-file-name))
        (backup-file (expand-file-name
                       (format "%s~" (file-name-nondirectory buf-file))
                       (file-name-directory buf-file))))
    (when (and buf-file (file-exists-p backup-file))
      (ediff-files buf-file backup-file))))



(defun my-compare-with-template-backup ()
  "Compare current file with backup named via #filename# template."
  (interactive)
  (let ((buf-file (buffer-file-name))
        (template (expand-file-name "#filename#" (file-name-directory buf-file)))
        (backup-file (format "%s~" (file-name-nondirectory buf-file)))
        (base-file (expand-file-name (format "%s" (file-name-nondirectory buf-file))
                                     (file-name-directory buf-file))))
    (ediff-files base-file backup-file)))
