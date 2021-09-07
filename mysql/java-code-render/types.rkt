#lang racket/base

(provide java-type-of)

(define type-mappings
  (make-immutable-hash
   (list '("bit" . "Boolean")
         '("tinyint" . "Integer")
         '("smallint" . "Integer")
         '("int" . "Integer")
         '("bigint" . "Long")
         '("float" . "Float")
         '("double" . "Double")
         '("decimal" . "BigDecimal")
         '("char" . "String")
         '("varchar" . "String")
         '("date" . "Date")
         '("datetime" . "Date")
         '("timestamp" . "Date")
         )))

(define (java-type-of db-field-type)
  (hash-ref type-mappings db-field-type))

(module+ test
  (require rackunit)
  (check-equal? (java-type-of "bit") "Boolean"))