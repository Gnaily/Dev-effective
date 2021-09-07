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

@;{;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;generate swagger annotated java code from db for fast copy/paste
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;}

@(define (field type name comment)
   @list{

 @"@"ApiModelProperty(value = "@|comment|")
 @"@"NotNull
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
 @"@"ApiModel("@(table-desc table)")
 @"@"Data
 class  @(snakecase->camelcase (table-name table)) {
  @(render-cols cols)
 }
 
 })
