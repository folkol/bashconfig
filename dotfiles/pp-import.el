;;; -*- Mode: emacs-lisp -*-
(provide 'pp-import)

(require 'url)

(defgroup pp-import nil
  "Customization for pp-import")

(defcustom pp-import-content-xml-url "http://localhost:8080/polopoly/import"
  "The import url for content xml defaults to 'http://localhost:8080/polopoly/import'"
  :type '(string)
  :group 'pp-import)

(defcustom pp-import-content-xml-user "sysadmin"
  "The import user for content xml defaults to 'sysadmin'"
  :type '(string)
  :group 'pp-import)

(defcustom pp-import-content-xml-passwd "sysadmin"
  "The password to use for the import user for content xml defaults to 'sysadmin'"
  :type '(string)
  :group 'pp-import)


(defun pp-import-content-xml ()
  (interactive)
  (setq xml-import-buffer (buffer-name))
  (message "Importing '%s'" (buffer-name))

  (let ((url-request-method "PUT")
        (url-request-extra-headers
         `(("Content-Type" . "text/xml;charset=UTF-8")
           ;; Not used atm since import servlet doesent handle basic auth
           ("Authorization" . ,(concat "Basic " (base64-encode-string 
                                                 (concat pp-import-content-xml-user
                                                         ":"
                                                         pp-import-content-xml-passwd))))))

        (url-request-data (buffer-string)))
    (url-retrieve (concat pp-import-content-xml-url 
                          "?username="
                          (url-hexify-string pp-import-content-xml-user)
                          "&password="
                          (url-hexify-string pp-import-content-xml-passwd)
                          "&result=true")
     'show-result)))

(defun show-result (status)
  (message (number-to-string (safe-length status)))
  (if (> (safe-length status) 0) (show-error status) (show-success)))

(defun show-success ()
  (kill-buffer (current-buffer))
  (message "successfully imported '%s'" xml-import-buffer))
  
  
(defun show-error (status)
  (switch-to-buffer (current-buffer)))