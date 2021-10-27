#lang scribble/text
@(require "../../mysql/table-model.rkt"
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
 @(cond [(equal? "id" name) "@TableId(value = \"id\", type = IdType.AUTO)"]
        [(equal? "create_time" name) @list{@"@"TableField(value = "@|name|", fill = FieldFill.INSERT)}]
        [(equal? "update_time" name) @list{@"@"TableField(value = "@|name|", fill = FieldFill.INSERT_UPDATE)}]
        [(equal? "deleted" name) @list{@"@"TableField(value = "@|name|")@"\n"@"@"TableLogic}]
        [else  @list{@"@"TableField(value = "@|name|")}])
 private @|type| @(snakecase->camelcase/lower name);
 
 })

@(for/list  ([(table) (in-sequences tables)])
   "\""
   (define cols (table-column-list table))
   (define (render-cols cols) 
     (map
      (lambda (col)
        ((lambda (type name  desc)
           (field (java-type-of type) name desc))
         (column-data-type col)  (column-name col) (column-desc col))) cols))

   @list{
 /**
 * @(table-desc table)
 * @"@"author yangliang <yangliang@"@"xx.com.cn>
 * @"@"date @(now-time-string)
 */
 @"@"Data
 @"@"TableName("@(table-name table)")
 public class  @(snakecase->camelcase (table-name table)) {
  @(render-cols cols)
 }
 
 })
