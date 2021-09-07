#lang racket/base
(require
  racket/string
  racket/date)

(provide now-time-string)

(define (now-time-string )
  (let ([d (current-date)])
    (string-append
     (string-join (map number->string (list (date-year d) (date-month d) (date-day d))) "/")
     " "
     (string-join (map number->string (list (date-hour d) (date-minute d) (date-second d))) ":"))))