#lang scribble/text
@(require "../table-model.rkt"
          "../../naming-style-conversion.rkt"
          "../../date-util.rkt"
          "./types.rkt")

@(define tables (list-tables
                 (connnect #:server "localhost"
                           #:port 3306
                           #:database "custom"
                           #:user "root"
                           #:password "a23456")))

@;{;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;generate java code
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;}

@(define (field type name comment)
   @list{

 /**
 *@|comment|
 */
 private @|type| @|name|;
 
 })

@(for/list  ([(table) (in-sequences tables)])
   
   (define cols (table-column-list table))
   (define (render-cols cols) 
     (map
      (lambda (col)
        ((lambda (type name  desc)
           (field (java-type-of type) (snakecase->camelcase/lower name) desc))
         (column-data-type col)  (column-name col) (column-desc col))) cols))

   @list{
 /**
 * @(table-desc table)
 * @"@"author yangliang <yangliang@"@"xx.com.cn>
 * @"@"date @(now-time-string)
 */
 @"@"Data
 public class  @(snakecase->camelcase (table-name table)) {
  @(render-cols cols)
 }
 
 })
