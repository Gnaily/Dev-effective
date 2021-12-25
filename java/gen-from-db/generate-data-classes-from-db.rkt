#lang scribble/text
@(require "../../mysql/table-model.rkt"
          "../../naming-style-conversion.rkt"
          "../../date-util.rkt"
          "./types.rkt")


@;{;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;generate java code
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;}

@(define (render-table table)
   @list{
 /**
 * @(table-desc table)
 * @"@"author yangliang <yangliang@"@"xx.com.cn>
 * @"@"date @(now-time-string)
 */
 @"@"Data
 public class  @(snakecase->camelcase (table-name table)) {
  @(map render-column
        (table-column-list table))
 }
 
})


@(define (java-field type name comment)
   @list{

 /**
 *@|comment|
 */
 private @|type| @|name|;
 
 })


@(define (render-column col)
   (let ([type (java-type-of (column-data-type col))]
         [name (snakecase->camelcase/lower (column-name col))]
         [desc (column-desc col)])
     (java-field type name desc)))


@(module+ main
        
   (define tables (list-tables
                   (connnect #:server "localhost"
                             #:port 3306
                             #:database "custom"
                             #:user "root"
                             #:password "a23456")))

   (for/list ([(table) (in-sequences tables)])
     (render-table table)))
