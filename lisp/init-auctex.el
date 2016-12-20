;; Set up LaTeX
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (setq TeX-auto-untabify t     ; remove all tabs before saving
				  TeX-engine 'xetex       ; use xelatex default
				  TeX-show-compilation t  ; display compilation windows
				  TeX-view-program-selection ; something complex
				  (quote
					(((output-dvi has-no-display-manager)
					  "dvi2tty")
					 ((output-dvi style-pstricks)
					  "dvips and gv")
					 (output-dvi "xdvi")
					 (output-pdf "mupdf")
					 (output-html "xdg-open"))))
			(TeX-global-PDF-mode t)       ; PDF mode enable, not plain
			(setq TeX-save-query nil)
			(define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)))

(provide 'init-auctex)
