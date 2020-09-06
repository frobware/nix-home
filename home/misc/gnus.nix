{ config, lib, pkgs, ... }:

{
  home.file.".config/gnus/dovecotrc-work-mbsync".text = ''
protocols = imap
mail_location =  maildir:~/Maildir/amcdermo@redhat.com:INBOX=~/Maildir/amcdermo@redhat.com/Inbox:LAYOUT=fs:INDEX=~/.dovecot-work-mbsync/indexes
ssl = no
disable_plaintext_auth = no
base_dir = ~/tmp
  '';

  home.file.".gnus.el".text = ''
(use-package simple
  :custom (read-mail-command #'gnus))

(use-package auth-source
  :config
  (setq auth-sources '("~/.authinfo.gpg" "~/.authinfo"))
  (setq user-full-name "Andrew McDermott")
  (setq user-mail-address "amcdermo@redhat.com"))

(use-package epa
  :config
  (setq epa-file-cache-passphrase-for-symmetric-encryption t)
  :init
  (epa-file-enable))

(use-package gnus
  :config
  (setq gnus-agent t)
  (setq gnus-always-read-dribble-file t)
  (setq gnus-article-save-directory "~/.config/gnus/news")
  (setq gnus-cache-directory "~/.config/gnus/news/cache")
  (setq gnus-check-new-newsgroups 'ask-server)
  (setq gnus-home-directory "~/.config/gnus")
  (setq gnus-kill-files-directory "~/.config/gnus/news")
  (setq gnus-novice-user nil)
  (setq gnus-read-active-file 'some)
  (setq gnus-registry-cache-file "~/.config/gnus/gnus.registry.eld")
  (setq gnus-select-method '(nnnil))
  (setq gnus-startup-file "~/.config/gnus/newsrc")
  (setq gnus-use-dribble-file t)
  (setq mail-source-directory "~/.config/gnus/mail")
  (setq mail-user-agent 'gnus-user-agent) ; also works with `sendmail-user-agent'
  (setq nndraft-directory "~/.config/gnus/drafts")
  (setq nnfolder-directory "~/.config/gnus/archive")
  (setq nnmh-directory "~/.config/gnus/drafts")
  (setq nnml-directory "~/.config/gnus/mail")
  (setq nntp-authinfo-file "~/.authinfo.gpg")
  (setq gnus-use-bbdb t))

(use-package gnus-group
  :after gnus
  :init
  :config
  (setq gnus-level-subscribed 6)
  (setq gnus-level-unsubscribed 7)
  (setq gnus-level-zombie 8)
  (setq gnus-activate-level 2)
  (setq gnus-list-groups-with-ticked-articles nil)
  (setq gnus-group-sort-function
        '((gnus-group-sort-by-unread)
          (gnus-group-sort-by-alphabet)
          (gnus-group-sort-by-rank)))
  (setq gnus-group-line-format "%M%p%P%5y:%B%(%g%)\n")
  (setq gnus-group-mode-line-format "%%b")
  :hook ((gnus-group-mode-hook . hl-line-mode)
         (gnus-select-group-hook . gnus-group-set-timestamp))
  :bind (:map gnus-group-mode-map
              ("M-n" . gnus-topic-goto-next-topic)
              ("M-p" . gnus-topic-goto-previous-topic)))

(require 'gnus-dired)
(require 'message)

(setq gnus-select-method '(nnnil))

(add-to-list 'gnus-secondary-select-methods
	     '(nnimap ""
		      (nnimap-stream shell)
		      (nnimap-shell-program "${pkgs.dovecot}/libexec/dovecot/imap -c ~/.config/gnus/dovecotrc-work-mbsync")))

(use-package gnus-sum
  :after (gnus gnus-group)
  :config
  (setq gnus-auto-select-first nil)
  (setq gnus-summary-ignore-duplicates t)
  (setq gnus-suppress-duplicates t)
  (setq gnus-summary-goto-unread nil)
  (setq gnus-summary-make-false-root 'adopt)
  (setq gnus-summary-thread-gathering-function 'gnus-gather-threads-by-subject)
  (setq gnus-thread-sort-functions
        '((not gnus-thread-sort-by-number)
          (not gnus-thread-sort-by-date)))
  (setq gnus-subthread-sort-functions
        'gnus-thread-sort-by-date)
  (setq gnus-thread-hide-subtree nil)
  (setq gnus-thread-ignore-subject t)
  (setq gnus-user-date-format-alist
        '(((gnus-seconds-today) . "Today at %R")
          ((+ 86400 (gnus-seconds-today)) . "Yesterday, %R")
          (t . "%Y-%m-%d %R")))
  (setq gnus-summary-line-format "%U%R%z %-16,16&user-date;  %4L:%-30,30f  %B%S\n")
  (setq gnus-summary-mode-line-format "Gnus: %p (%U)")
  (setq gnus-sum-thread-tree-false-root "")
  (setq gnus-sum-thread-tree-indent " ")
  (setq gnus-sum-thread-tree-leaf-with-other "├─➤ ")
  (setq gnus-sum-thread-tree-root "")
  (setq gnus-sum-thread-tree-single-leaf "└─➤ ")
  (setq gnus-sum-thread-tree-vertical "│")
  :hook
  (gnus-summary-exit-hook . gnus-topic-sort-groups-by-alphabet)
  (gnus-summary-exit-hook . gnus-group-sort-groups-by-rank)
  :bind (:map gnus-agent-summary-mode-map
              ("<delete>" . gnus-summary-delete-article)
              ("n" . gnus-summary-next-article)
              ("p" . gnus-summary-prev-article)
              ("N" . gnus-summary-next-unread-article)
              ("P" . gnus-summary-prev-unread-article)
              ("M-n" . gnus-summary-next-thread)
              ("M-p" . gnus-summary-prev-thread)
              ("C-M-n" . gnus-summary-next-group)
              ("C-M-p" . gnus-summary-prev-group)
              ("C-M-^" . gnus-summary-refer-thread)))

(use-package gnus-art
  :after gnus
  :config
  (setq gnus-article-browse-delete-temp 'ask)
  (setq gnus-article-over-scroll nil)
  (setq gnus-article-show-cursor t)
  (setq gnus-article-sort-functions
        '((not gnus-article-sort-by-number)
          (not gnus-article-sort-by-date)))
  (setq gnus-article-truncate-lines nil)
  (setq gnus-html-frame-width 80)
  (setq gnus-html-image-automatic-caching t)
  (setq gnus-inhibit-images t)
  (setq gnus-max-image-proportion 0.7)
  (setq gnus-treat-display-smileys nil)
  (setq gnus-article-mode-line-format "%G %S %m")
  (setq gnus-visible-headers
        '("^From:" "^Subject:" "^To:" "^Cc:" "^Newsgroups:" "^Date:"
          "Followup-To:" "Reply-To:" "^Organization:" "^X-Newsreader:"
          "^X-Mailer:"))
  (setq gnus-sorted-header-list gnus-visible-headers)
  :hook (gnus-article-mode-hook . (lambda ()
                                    (setq-local fill-column 80)))
  :bind (:map gnus-article-mode-map
              ("i" . gnus-article-show-images)
              ("s" . gnus-mime-save-part)
              ("o" . gnus-mime-copy-part)))
  '';
}
