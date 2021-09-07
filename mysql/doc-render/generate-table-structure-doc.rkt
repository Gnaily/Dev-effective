#lang scribble/text
@(require "../table-model.rkt")

@(define tables (list-tables
                 (connnect #:server "localhost"
                           #:port 3306
                           #:database "test"
                           #:user "root"
                           #:password "a23456")))

@(for/list  ([(table) (in-sequences tables)])
   
   (define cols (table-column-list table))
   (define (render-cols cols) 
     (map
      (lambda (col)
        ((lambda (name type nullable default desc)
           @list{| @|name| | @|type| | @|nullable| | @|default| | @|desc| |

 })
         (column-name col) (column-type col) (column-nullable col)
         (column-default col) (column-desc col))) cols))

   @list{
         
       ###  @(table-desc table)(@(table-name table))
           
         | 字段名| 类型  | 是否为空 | 默认值| 注释 |
         | -----| -----| ------- | -----| ----|   
         @(render-cols cols)})


