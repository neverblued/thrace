;; (c) Дмитрий Пинский <mail@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(defpackage #:thrace-system
  (:use #:common-lisp #:asdf))

(in-package #:thrace-system)

(defsystem "thrace"
  :description "Test Trace for SBCL"
  :version "0.1"
  :serial t
  :components ((:file "package")
               (:file "steel-bank")
               (:file "intercept")
               (:file "pretty")
               (:file "format")
               (:file "example")))
