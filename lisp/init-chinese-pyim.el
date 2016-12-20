;; {{ make IME compatible with evil-mode
(defun evil-toggle-input-method ()
  "when toggle on input method, goto evil-insert-state. "
  (interactive)

  ;; load IME when needed, less memory footprint
  (unless (featurep 'chinese-pyim)
    (require 'chinese-pyim))

  ;; some guy don't use evil-mode at all
  (cond
   ((and (boundp 'evil-mode) evil-mode)
    ;; evil-mode
    (cond
     ((eq evil-state 'insert)
      (toggle-input-method))
     (t
      (evil-insert-state)
      (unless current-input-method
        (toggle-input-method))
      ))
    (if current-input-method (message "IME on!")))
   (t
    ;; NOT evil-mode
    (toggle-input-method))))

(defadvice evil-insert-state (around evil-insert-state-hack activate)
  ad-do-it
  (if current-input-method (message "IME on!")))

(global-set-key (kbd "C-\\") 'evil-toggle-input-method)

;; (global-set-key (kbd "M-j") 'pyim-convert-code-at-point)
;; }}

;; (setq pyim-punctuation-translate-p nil) ;; use western punctuation (ban jiao fu hao)

;; ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
;; ;; 我自己使用的中英文动态切换规则是：
;; ;; 1. 光标只有在注释里面时，才可以输入中文。
;; ;; 2. 光标前是汉字字符时，才能输入中文。
;; ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
;; (setq-default pyim-english-input-switch-functions
;;               '(pyim-probe-dynamic-english
;;                 pyim-probe-isearch-mode
;;                 pyim-probe-program-mode
;;                 pyim-probe-org-structure-template))

;; (setq-default pyim-punctuation-half-width-functions
;;               '(pyim-probe-punctuation-line-beginning
;;                 pyim-probe-punctuation-after-punctuation))


;; ;; 让 Emacs 启动时自动加载 pyim 词库
;; (add-hook 'emacs-startup-hook
;;           #'(lambda () (pyim-restart-1 t)))

(eval-after-load 'chinese-pyim
  '(progn
     (global-set-key (kbd "C-.") 'pyim-toggle-full-width-punctuation)
     (setq default-input-method "chinese-pyim")
     (setq pyim-use-tooltip 'pos-tip) ; don't use tooltip
     (setq x-gtk-use-system-tooltips t)
     ;; personal dictionary should be out of ~/.emacs.d if possible
     (if (file-exists-p (file-truename "~/.eim/pyim-personal.txt"))
         (setq pyim-personal-file "~/.eim/pyim-personal.txt"))
     ;; another official dictionary
     (setq pyim-dicts '((:name "pinyin1" :file "~/.emacs.d/pyim/py.txt" :coding utf-8-unix :dict-type pinyin-dict)))


     (defun pyim-fuzzy-pinyin-adjust-shanghai ()
       "As Shanghai guy, I can't tell difference between:
  - 'en' and 'eng'
  - 'in' and 'ing'"
       (interactive)
       (cond
        ((string-match-p "[a-z][ei]ng?-.*[a-z][ei]ng?" pyim-current-key)
         ;; for two fuzzy pinyin characters, just use its SHENMU as key
         (setq pyim-current-key (replace-regexp-in-string "\\([a-z]\\)[ie]ng" "\\1" pyim-current-key)))
        (t
         ;; single fuzzy pinyin character
         (cond
          ((string-match-p "[ei]ng" pyim-current-key)
           (setq pyim-current-key (replace-regexp-in-string "\\([ei]\\)ng" "\\1n" pyim-current-key)))
          ((string-match-p "[ie]n[^g]*" pyim-current-key)
           (setq pyim-current-key (replace-regexp-in-string "\\([ie]\\)n" "\\1ng" pyim-current-key))))))
       (pyim-handle-string))

     ;; Comment out below line for default fuzzy algorithm,
     ;; or just `(setq pyim-fuzzy-pinyin-adjust-function nil)`
     (setq pyim-fuzzy-pinyin-adjust-function 'pyim-fuzzy-pinyin-adjust-shanghai)))

(provide 'init-chinese-pyim)
