;; (c) Дмитрий Пинский <mail@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:thrace-test)

(defparameter pop-error? nil)

(defparameter show-local? nil)

(defun hello-world ()
  (break "FFFFFUUU-"))

(defun test (&key (stream *debug-io*) (limit 5))
  (intercept-error (:allow-pop pop-error?)
      (progn (hello-world)
             (format stream "~&never printed"))
    (format stream "~&break interception")
    (let ((stack (compute-backtrace limit)))
      (format-backtrace stream stack :local-variable-values show-local?))))
