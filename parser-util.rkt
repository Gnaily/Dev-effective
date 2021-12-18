#lang racket

(provide skip-space/p
         part-of-word/p
         field/p
         field-type/p
         text/p)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require racket/string)
(require data/monad)
(require data/applicative)
(require megaparsack megaparsack/text)

; a skip space parser 
(define skip-space/p
  (do [list <- (many/p (char/p #\ ))]
    (pure void/p)))

;parse part of a word
(define part-of-word/p
  (or/p letter/p (char-ci/p #\_)))

(define field/p
  (do (many/p space/p)
    [list <- (many/p part-of-word/p)]
    (pure (list->string list))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; parse one of:
; - String
; - String[]
(define field-type/p
  (or/p
   (try/p (do (skip-space/p)
     [list <-  (many/p letter/p)]
     [s <- (string/p "[]")]
     (pure (string-append (list->string list) s))))

   (do (skip-space/p)
     [list <-  (many/p letter/p)]
     (pure   (list->string list)))))

(define text/p
  (do (skip-space/p)
    [list <- (many/p (char-not/p #\tab))]
    (pure (list->string list))))

(define row/p
  (list/p  #:sep (char/p #\tab)
           field/p field-type/p text/p text/p text/p text/p))



(module+ test
  (require rackunit)
  
  (check-eq? 112 (parse-result! (parse-string (do skip-space/p integer/p) "   112")))
  (check-equal? "a_eeb_Cd" (parse-result! (parse-string field/p "       a_eeb_Cd cd\t")))
  (check-equal? "String[]" (parse-result! (parse-string field-type/p "String[] cd\t")))

  (define t "subject	 String	必选	256	订单标题。
注意：不可使用特殊字符，如 /，=，& 等。	Iphone6 16G")
  (define t1 "out_trade_no	String	必选	64	商户订单号。
由商家自定义，64个字符以内，仅支持字母、数字、下划线且需保证在商户端不重复。	20150320010101001
	total_amount	Price	必选	9	订单总金额。
单位为元，精确到小数点后两位，取值范围：[0.01,100000000] 。	88.88
	subject	String	必选	256	订单标题。
注意：不可使用特殊字符，如 /，=，& 等。	Iphone6 16G")
  ;t1 以tab开始
  ; (parse-result! (parse-string (repeat/p 3 row/p ) t1)) )

  (define t2 "logistics_detail	LogisticsDetail	可选		物流信息	")
  t2
  (parse-result! (parse-string (repeat/p 1 row/p ) t2)) )

 

