(in-package #:thrace)

;; code origin:
;; http://jsnell.iki.fi/blog/archive/2007-12-19-pretty-sbcl-backtraces.html

(defun find-line-position (char-offset frame)
  (ignore-errors
   (let* ((location (sb-di::frame-code-location frame))
          (debug-source (sb-di::code-location-debug-source location))
          (file (debug-source-namestring debug-source))
          (line (with-open-file (stream file)
                  (1+ (loop repeat char-offset
                            count (eql (read-char stream) #\Newline))))))
     (format nil "~:[~a (file modified)~;~a~]"
             (= (file-write-date file)
                (sb-di::debug-source-created debug-source))
             line))))
