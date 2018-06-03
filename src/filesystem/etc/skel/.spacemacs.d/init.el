(defun dotspacemacs/layers ()
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation 'unused
   dotspacemacs-ask-for-lazy-installation t
   dotspacemacs-configuration-layer-path '("~/.spacemacs.d/layers")
   dotspacemacs-configuration-layers
   '(
     asm
     auto-completion
     c-c++
     chrome
     colors
     common-lisp
     cscope
     csharp
     csv
     deft
     django
     docker
     elfeed
     emacs-lisp
     extra-langs
     fasd
     finance
     floobits
     games
     git
     github
     go
     gtags
     helm
     html
     imenu-list
     itome-react
     java
     javascript
     lua
     markdown
     nginx
     nlinum
     org
     pandoc
     pdf-tools
     php
     plantuml
     prodigy
     python
     ranger
     restclient
     ruby
     ruby-on-rails
     search-engine
     semantic
     shell
     shell-scripts
     speed-reading
     spell-checking
     sql
     syntax-checking
     systemd
     terraform
     themes-megapack
     twitter
     typescript
     typography
     version-control
     wakatime
     windows-scripts
     yaml
     ycmd
     )
   dotspacemacs-additional-packages
   '(
     add-node-modules-path
     editorconfig
     prettier-js
     xclip
     )
   dotspacemacs-frozen-packages '()
   dotspacemacs-excluded-packages '()
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  (setq-default
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-check-for-update nil
   dotspacemacs-elpa-subdirectory nil
   dotspacemacs-editing-style 'vim
   dotspacemacs-verbose-loading nil
   dotspacemacs-startup-banner '000
   dotspacemacs-startup-lists
   '(
     (recents . 5)
     (projects . 7)
     )
   dotspacemacs-startup-buffer-responsive t
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-themes
   '(
     spacemacs-dark
     spacemacs-light
     )
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font
   '(
     "Source Code Pro"
     :size 13
     :weight normal
     :width normal
     :powerline-scale 1.1
     )
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-distinguish-gui-tab nil
   dotspacemacs-remap-Y-to-y$ nil
   dotspacemacs-retain-visual-state-on-shift t
   dotspacemacs-visual-line-move-text nil
   dotspacemacs-ex-substitute-global nil
   dotspacemacs-default-layout-name "Default"
   dotspacemacs-display-default-layout nil
   dotspacemacs-auto-resume-layouts nil
   dotspacemacs-large-file-size 1
   dotspacemacs-auto-save-file-location 'cache
   dotspacemacs-max-rollback-slots 5
   dotspacemacs-helm-resize nil
   dotspacemacs-helm-no-header nil
   dotspacemacs-helm-position 'bottom
   dotspacemacs-helm-use-fuzzy 'always
   dotspacemacs-enable-paste-transient-state nil
   dotspacemacs-which-key-delay 0.4
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-loading-progress-bar t
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup nil
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 90
   dotspacemacs-show-transient-state-title t
   dotspacemacs-show-transient-state-color-guide t
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-smooth-scrolling t
   dotspacemacs-line-numbers nil
   dotspacemacs-folding-method 'evil
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-smart-closing-parenthesis nil
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-persistent-server nil
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   dotspacemacs-default-package-repository nil
   dotspacemacs-whitespace-cleanup 'trailing
   ))

(defun dotspacemacs/user-init ()
  (setq exec-path-from-shell-arguments '("-l"))
  )

(defun dotspacemacs/user-config ()
  (setq recentf-save-file (format "/tmp/recentf.%s" (emacs-pid)))
  (editorconfig-mode 1)
  (add-to-list 'auto-mode-alist '("\\.dat\\'" . ledger-mode))
  (add-to-list 'auto-mode-alist '("\\.\\\(j\\|t\\\)sx?\\'" . rjsx-mode))
  (add-to-list 'auto-mode-alist '("\\.vue\\'" . rjsx-mode))
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'json-mode-hook 'prettier-js-mode)
  (add-hook 'rjsx-mode-hook 'prettier-js-mode)
  (eval-after-load 'rjsx-mode
    '(add-hook 'js-mode-hook #'add-node-modules-path))
  (eval-after-load 'js2-mode
    '(add-hook 'js-mode-hook #'add-node-modules-path))
  (eval-after-load 'javascript-mode
    '(add-hook 'js-mode-hook #'add-node-modules-path))
  (xclip-mode 1)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (add-node-modules-path xclip rjsx-mode prettier-js editorconfig xterm-color wakatime-mode twittering-mode terraform-mode hcl-mode systemd spray shell-pop restclient-helm ranger prodigy pdf-tools pandoc-mode ox-pandoc ob-restclient ob-http nginx-mode multi-term ledger-mode imenu-list gmail-message-mode ham-mode html-to-markdown flymd flycheck-ycmd flycheck-ledger fasd eshell-z eshell-prompt-extras esh-help engine-mode elfeed-web elfeed-org elfeed-goodies ace-jump-mode noflet elfeed edit-server dockerfile-mode docker tablist docker-tramp deft company-ycmd ycmd request-deferred deferred company-restclient restclient know-your-http-well zenburn-theme zen-and-art-theme white-sand-theme underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme toxi-theme tao-theme tangotango-theme tango-plus-theme tango-2-theme swift-mode sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spacegray-theme soothe-theme solarized-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme smeargle seti-theme reverse-theme rebecca-theme rainbow-mode rainbow-identifiers railscasts-theme purple-haze-theme professional-theme planet-theme phoenix-dark-pink-theme phoenix-dark-mono-theme orgit organic-green-theme omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme nlinum-relative nlinum naquadah-theme mustang-theme monokai-theme monochrome-theme molokai-theme moe-theme minimal-theme material-theme majapahit-theme magit-gitflow magit-gh-pulls madhat2r-theme lush-theme light-soap-theme jbeans-theme jazz-theme ir-black-theme inkpot-theme heroku-theme hemisu-theme helm-gtags helm-gitignore helm-cscope xcscope hc-zenburn-theme gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme gitignore-mode github-search github-clone github-browse-file gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter gist gh marshal logito pcache ht ggtags gandalf-theme floobits flatui-theme flatland-theme farmhouse-theme exotica-theme evil-magit magit magit-popup git-commit ghub let-alist with-editor espresso-theme dracula-theme django-theme diff-hl darktooth-theme autothemer darkokai-theme darkmine-theme darkburn-theme dakrone-theme cyberpunk-theme color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized color-identifiers-mode clues-theme cherry-blossom-theme busybee-theme bubbleberry-theme birds-of-paradise-plus-theme badwolf-theme apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme alect-themes afternoon-theme ws-butler winum which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline powerline restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox spinner org-plus-contrib org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint indent-guide hydra hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-themes helm-swoop helm-projectile helm-mode-manager helm-make projectile pkg-info epl helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu highlight elisp-slime-nav dumb-jump f dash s diminish define-word column-enforce-mode clean-aindent-mode bind-map bind-key auto-highlight-symbol auto-compile packed aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core popup async))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))
