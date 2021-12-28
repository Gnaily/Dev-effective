#lang scribble/text
@(require
   megaparsack
   megaparsack/text
   "../file-util.rkt"
   "../naming-style-conversion.rkt"
   "../parser-util.rkt")


@;{;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;generate java code
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;}


@(define (parse n text)
   ;parse a row
   (define row/p
     (list/p  #:sep (char/p #\tab)
              field/p field-type/p text/p text/p text/p text/p))
   (parse-result! (parse-string (repeat/p n row/p ) text)))


@;;;;;;;;;;;;;;;;;;;;;template;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@(define (field type name comment example require max-size)
   @list{

 /**
 *@|comment|<br>
 *示例值:@|example|
 */
 @"@"JSONField(name ="@|name|")
 @(if (equal? max-size "") "" @list{@"@"Size(max = @|max-size|)})
 @(if (equal? require "必选") "@NotBlank" "")private @|type| @(snakecase->camelcase/lower name);
 
 })

@(module+ main
   ;;;;;;;;;;; generate java field from a file;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; 
   ; 1. copy data from a table (web table/excel,ect)
   ; 2. save to a file
   ; 3. generate java code
   ;
   ; Below is a example
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   @(for/list ([(col) (in-sequences (parse 19   (file->string "table-data-example(splited-by-tab).txt")))])
      (field (list-ref col 1) (list-ref col 0)
             (list-ref col 4) (list-ref col 5) (list-ref col 2) (list-ref col 3))))