;;; unbind.el --- Commands for unbinding things
;; Copyright 2002-2017 by Dave Pearson <davep@davep.org>

;; Author: Dave Pearson <davep@davep.org>
;; Version: 1.5
;; Keywords: lisp, unbind
;; URL: https://github.com/davep/unbind.el

;; This program is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation, either version 3 of the License, or (at your
;; option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
;; Public License for more details.
;;
;; You should have received a copy of the GNU General Public License along
;; with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; unbind.el provides some simple commands for unbinding values in Emacs
;; Lisp. I find this handy when working on code.

;;; Code:

(require 'help-fns)

;;;###autoload
(defun unbind-defun ()
  "Unbind the `defun' near `point' in `current-buffer'."
  (interactive)
  (save-excursion
    (if (and (beginning-of-defun) (looking-at "(defun"))
        (fmakunbound (cadr (read (current-buffer))))
      (error "No defun found near point"))))

;;;###autoload
(defun unbind-symbol (symbol)
  "Totally unbind SYMBOL.

This includes unbinding its function binding, its variable binding and its
property list."
  (interactive "SSymbol: ")
  (fmakunbound symbol)
  (makunbound symbol)
  (setf (symbol-plist symbol) nil))

;;;###autoload
(defun unbind-function (symbol)
  "Remove the function binding of SYMBOL."
  (interactive "aFunction: ")
  (fmakunbound symbol))

;;;###autoload
(defun unbind-command (symbol)
  "Remove the command binding of SYMBOL."
  (interactive "CCommand: ")
  (fmakunbound symbol))

;;;###autoload
(defun unbind-variable (symbol)
  "Remove the variable binding of SYMBOL."
  (interactive (list (completing-read "Variable: " obarray #'boundp t
                                      (let ((v (variable-at-point)))
                                        (when (symbolp v) (symbol-name v))))))
  (makunbound (if (stringp symbol) (intern symbol) symbol)))

(provide 'unbind)

;;; unbind.el ends here
