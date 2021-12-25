#lang scribble/text
@(require
   racket/port
   sxml
   html-parsing
   "../naming-style-conversion.rkt"
   "../parser-util.rkt")

@;;;;;;;;;;;;;;;;;;;;;template;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@(define (field type name comment example require max-size)
   @list{

 /**
 *@|comment|<br>
 *示例值:@|example|
 */
 @"@"XmlElement(name ="@(string-trim name)")
 @filter[(lambda (e) (not (void? e)))
         @(list
           @unless[(equal? max-size "")]{
           @list{
            @"@"Size(max = @|max-size|)
             
          }}
           
           @when[(equal? require "是")]{
           @list{
            @"@"NotBlank
             
           }
           } )]private @(snakecase->camelcase type) @(snakecase->camelcase/lower name);

 })

@(module+ main

   (define (file-content file)
     (port->string (open-input-file file) #:close? #t))


   (define (filter-sxml-element list)
     (filter (lambda (e)  (sxml:element? e)) list))


   (define (text sxml-element)
     (define mapper
       (lambda (e)
         (cond [(string? e) e]
               [(sxml:node? e) (text e)])))
     (string-append* (map mapper
                          (sxml:content sxml-element))))
   
   ;;;;;;;;;;; generate java field from a xml file;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; 
   ; 1. select web table data, copy it's html source code
   ; 2. save xml content in a file
   ; 3. run below code to generate java code
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   (define xexpr (html->xexp
                  (file-content "table-data-example.xml")))
  
   (define table
     (map  (lambda (tr)  (cons 'tr ((sxpath '(td))  tr)))
           ((sxpath '(tbody tr)) xexpr)))


   (for/list ([(row) (in-sequences table)])
     (define type_and_len
       (string-split
        (text (list-ref row 4)) "("))
     (field
      (list-ref type_and_len 0 )
      (sxml:text (list-ref row 2))
      (text (list-ref row 6))
      (text (list-ref row 5))
      (sxml:text (list-ref row 3))
      (if (> (length type_and_len) 1)
          (list-ref (string-split (list-ref type_and_len 1) ")") 0)
          "") ) ))