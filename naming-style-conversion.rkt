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

(define (snakecase->camelcase/lower str)
  (camelcase/lower* (string-split str "_")))

(define (snakecase->camelcase str)
  (camelcase* (string-split str "_")))

(module+ test
  (string-upcase "sss-s")
  (string-titlecase "Databaseuser")
  (snakecase  "x" )
  (snakecase  "x" "y")
  (snakecase* (list "x" "y"))
  (camelcase  "ab")
  (camelcase  "ab" "cd")
  (camelcase/lower "a" "b")
  (camelcase/lower "aaa" "bbb")
  (snakecase->camelcase "aaa_bbb_cc")
  (snakecase->camelcase/lower "aaa_bbb_cc"))