;; (c) Дмитрий Пинский <mail@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:thrace)

(defparameter *local-variable-values* nil)

(defun format-fun-args (stream frame fun)
  (let ((flags '(:key :optional :rest)))

    (labels ((flag (this)
               (find this flags))
             (item-flag (item)
               (and (listp item) (flag (first item))))
             (item-var (item)
               (second item))
             (var? (this)
               (typep this 'sb-di::debug-var))

             (format-var (this)
               (let ((name (debug-var-symbol-name this))
                     (value (debug-var-value this frame)))
                 (if *local-variable-values*
                     (format stream ":~a ~s " name value)
                     (format stream "~a " name))))
             (format-flag (this)
               (format stream "&~a " (symbol-name this)))

             (format-item (this)
               (let ((flag (item-flag this)))
                 (cond ((var? this)
                        (format-var this))
                       (flag
                        (format-flag flag)
                        (format-var (item-var this)))
                       (t nil)))))
      (handler-case
          (mapcar #'format-item (debug-fun-lambda-list fun))
        (error (condition)
          (format stream "< arguments error: ~a >" condition))))))

(defun format-frame (stream frame)
  (let* ((index (frame-number frame))
         (location (code-location-debug-source (frame-code-location frame)))
         (file-path (debug-source-namestring location))
         (line-position (find-line-position 0 frame))
         (fun (frame-debug-fun frame))
         (fun-name (debug-fun-name fun)))
    (format stream "~&~d :: ~a" index file-path)
    (when line-position
      (format stream " :: ~a" line-position))
    (format stream "~&<( ~a " fun-name)
    (format-fun-args stream frame fun)
    (format stream ")>~&")
    t))

(defun format-backtrace (stream stack
                         &key (local-variable-values *local-variable-values*))
  "@TODO: like in SLDB, with references to files and line numbers"
  (let ((*local-variable-values* local-variable-values))
    (mapcar (lambda (frame)
              (format-frame stream frame))
            stack)))
