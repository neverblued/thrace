;; (c) Дмитрий Пинский <mail@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:thrace)

(defmacro with-hook (condition handler &body body)
  (let ((hook (gensym "HOOK")))
    `(let ((*invoke-debugger-hook* (lambda (,condition ,hook)
                                     (declare (ignore ,hook))
                                     ,handler)))
       ,@body)))

(defparameter trace-length 10)

(defparameter trace-start-fun-name 'invoke-debugger)

(defun compute-backtrace (&optional (length trace-length))
  (flet ((start-collecting? (frame)
           (let* ((fun (frame-debug-fun frame))
                  (name (debug-fun-name fun)))
             (eql name trace-start-fun-name))))
    (let* ((frame (top-frame)) (number 0) collect? stack)
      (loop (unless (and frame (< number length))
              (return-from nil))
            (if collect?
                (progn (push frame stack)
                       (incf number))
                (when (start-collecting? frame)
                  (setf collect? t)))
         (setf frame (frame-down frame)))
      (reverse stack))))
