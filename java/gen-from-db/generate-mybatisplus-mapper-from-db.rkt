#lang scribble/text
@(require "../../mysql/table-model.rkt"
          "../../naming-style-conversion.rkt"
          "../../date-util.rkt"
          "./types.rkt")

@(define tables (list-tables
                 (connnect #:server "47.108.133.21"
                           #:port 6033
                           #:database "wzl_group_order"
                           #:user "root"
                           #:password "riC%sdsdsD^^68$##rwwdPTO%a6s&a")
                 "order_daily_sequence" ))

@;{;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;generate java code
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;}

@(for/list  ([(table) (in-sequences tables)])
    
   (define entity-name (snakecase->camelcase (table-name table)))
   @list{
 /**
 * @(table-desc table) Mapper
 * @"@"author yangliang <yangliang@"@"xx.com.cn>
 * @"@"date @(now-time-string)
 */
 @"@"Repository
 public interface  @|entity-name|Mapper  extends CrudMapper<@|entity-name|>  {

 }
 
 })
