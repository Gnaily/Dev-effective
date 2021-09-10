#lang racket/base
(require racket/contract
         racket/string)

(provide  (rename-out [string-upcase upcase])
          (rename-out [string-downcase downcase])
          (rename-out [string-titlecase titlecase])
          (contract-out [snakecase (-> (list/c string?) string?)])
          camelcase
          camelcase*
          camelcase/lower*
          camelcase/lower
          camelcase->camelcase/lower
          snakecase->camelcase
          snakecase->camelcase/lower)

(define (snakecase . string)
  (snakecase* string))

(define (snakecase*  str-list)
  (string-join str-list "_"))

(define (camelcase/lower . string)
  (camelcase/lower* string))

(define (camelcase/lower* str-list)
  (string-append (string-downcase (car str-list)) (camelcase* (cdr str-list))))

(define (camelcase . string)
  (camelcase* string))

(define (camelcase* str-list)
  (string-append* (map string-titlecase str-list)))

(define (camelcase->camelcase/lower str)
  (let ([len (string-length str)])
    (if (> len 0)
        (string-append
         (string-downcase (string (string-ref str 0)))
         (substring  str 1))
        str)))

(define (snakecase->camelcase/lower str)
  (camelcase/lower* (string-split str "_")))

(define (snakecase->camelcase str)
  (camelcase* (string-split str "_")))

(module+ test
  (require rackunit)
  (check-equal? (string-upcase "sss-s") "SSS-S")
  (check-equal? (string-titlecase "Databaseuser") "Databaseuser")
  (check-equal? (snakecase  "x" ) "x")
  (check-equal? (snakecase  "x" "y") "x_y")
  (check-equal? (snakecase* (list "x" "y")) "x_y")
  (check-equal? (camelcase  "ab") "Ab")
  (check-equal? (camelcase  "ab" "cd") "AbCd")
  (check-equal? (camelcase/lower "a" "b") "aB")
  (check-equal? (camelcase/lower "aaa" "bbb") "aaaBbb")
  (check-equal? (snakecase->camelcase "aaa_bbb_cc") "AaaBbbCc")
  (check-equal? (snakecase->camelcase/lower "aaa_bbb_cc") "aaaBbbCc")
  (check-equal? (camelcase->camelcase/lower "AbcDe" ) "abcDe"))