;; (c) Дмитрий Пинский <mail@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(defpackage #:thrace
  (:use #:common-lisp #:sb-ext #:sb-debug #:sb-di)
  (:export #:intercept-error #:compute-backtrace #:format-backtrace))

(defpackage #:thrace-test
  (:use #:common-lisp #:thrace))
