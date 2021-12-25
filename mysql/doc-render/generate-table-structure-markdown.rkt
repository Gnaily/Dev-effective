#lang scribble/text
@(require "../table-model.rkt")

@(define (render-table table)
   @list{
         
 ###  @(table-desc table)(@(table-name table))
 | 字段名| 类型  | 是否为空 | 默认值| 注释 |
 | -----| -----| ------- | -----| ----|   
 @(map render-column (table-column-list table))
 })


@(define (render-column col)
   (let ([name (column-name col)]
         [type (column-type col)]
         [nullable (column-nullable col)]
         [default (column-default col)]
         [desc (column-desc col)])
     @list{| @|name| | @|type| | @|nullable| | @|default| | @|desc| | @"\n"}))


@(module+ main   
   (define tables (list-tables
                   (connnect #:server "localhost"
                             #:port 3306
                             #:database "test"
                             #:user "root"
                             #:password "a23456")))

   (for/list ([(table) (in-sequences tables)])
     (render-table table)))

