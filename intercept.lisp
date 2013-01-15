;; (c) Дмитрий Пинский <mail@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:thrace)

(defmacro with-debugger (&body body)
  (let ((condition (gensym "CONDITION")))
    `(restart-case
         (progn ,@body)
       (debugger (,condition)
         (invoke-debugger ,condition)))))

(defun debug-intercepted (condition)
  (invoke-restart 'debugger condition))

(defmacro intercept-error ((&key allow-pop) body &body handler)
  (let* ((condition (gensym "CONDITION"))
         (show-debugger `(debug-intercepted ,condition)))
    `(with-debugger (with-hook ,condition
                        (progn ,@handler
                               (if ,allow-pop ,show-debugger (abort ,condition)))
                      (handler-case ,body
                        (error (,condition) ,show-debugger))))))
