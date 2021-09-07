#lang racket/base

(provide (struct-out table)
         (struct-out column)
         list-tables connnect)

(require racket/list)
(require racket/string)
(require racket/format)
(require db)


(struct conn-holder [conn db])
(define (connnect
         #:server server  
         #:port port
         #:database db 
         #:user u
         #:password psw)
  
  (conn-holder (mysql-connect
                #:server server
                #:port port
                #:database db
                #:user u
                #:password psw) db))

(struct table [name desc column-list] #:transparent)
(struct column [name
                desc
                data-type
                type
                nullable
                default
                numeric-len
                numberic-scale
                character-max-len
                key
                ] #:transparent)

;(call (connect ...)) string ... -> List[table]
(define (list-tables conn-holder . table-name)

  (define ret
    (for/list ([(name desc) (in-query
                             (conn-holder-conn conn-holder)
                             (cons-query-tables-sql
                              (conn-holder-db conn-holder) table-name))])
      (table name desc (list-cols conn-holder name))))
  (disconnect  (conn-holder-conn conn-holder))

  ret)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                     Query tables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;String List[String] -> String
(define (cons-query-tables-sql db table-name )
  (let ([db (wrapp-quote db)])
    (if (empty? table-name) (format query-tables-sql db)
        (format query-tables-sql (string-append db (and-in table-name))))))

(define query-tables-sql
  "SELECT
     table_name,
     table_comment
   FROM
     information_schema.TABLES
   WHERE
     table_schema =~a 
   ORDER BY table_name")

(define (and-in name-list)
  (define wrapped
    (map (lambda (s) (wrapp-quote s)) name-list))
  (string-append
   "and table_name in (" (string-join wrapped ",") ")"))

(define (wrapp-quote s)
  (string-append "'" s "'"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                     Query table colums
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (list-cols conn-holder table-name)
  (define (downcase s)
     (string-downcase (if (bytes? s) (bytes->string/utf-8 s) s)))
  (for/list ([(name
               desc
               data-type
               type
               nullable
               default
               numeric-len
               numberic-scale
               char-len
               key) (in-query (conn-holder-conn conn-holder)
                              (cons-query-cols-sql (conn-holder-db conn-holder) table-name))])
    
    (column name
            (downcase desc)
            (downcase data-type)
            (downcase type)
            (downcase nullable)
            (cond [(sql-null? default)
                   (if (equal? "yes" (downcase nullable))  "Null" "")]
                  [else default])
            numeric-len
            numberic-scale
            char-len
            key)))

(define (cons-query-cols-sql db table-name)
  (define query-cols-sql
    "select
    column_name as name,
    column_comment AS `desc`,
    data_type AS `data-type`,
    column_type AS `type`,
    is_nullable as nullable,
    column_default AS `default`,
    numeric_precision AS `numeric-len`,
    numeric_scale AS `numberic-scale`,
    character_octet_length AS `char-len`,
    column_key AS `key`
   from 
     information_schema.columns 
   where
     table_schema = '~a' and table_name = '~a'
   order by ordinal_position asc")
  (format query-cols-sql db table-name))

(module+ test
  (display (cons-query-tables-sql "test_db" empty))
  (display "\n\n")
  (display (cons-query-tables-sql "test_db" (list "x" "y")))
  (display "\n\n")
  (display (cons-query-cols-sql "test_db" "my_test_table1"))
  (display "\n\n")

  #;{(list-tables
      (connnect #:server "localhost"
                #:port 3306
                #:database "my_db"
                #:user "root"
                #:password "a23456")
      "my_test_table1" "my_test_table2")})
