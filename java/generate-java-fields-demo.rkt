#lang scribble/text

@(define (template index)
   ; use string-append
   @string-append{

                  
 @"@"XmlElement(name = "coupon_type_$@|index|")
 private String couponType$@|index|;

 
 @"@"XmlElement(name = "coupon_refund_id_$@|index|")
 private String couponRefundId$@|index|;

 
 @"@"XmlElement(name = "coupon_refund_fee_$@|index|")
 private Integer couponRefundFee$@|index|;
 })

@(module+ main
    ;generate 50 times
   (for/list ([j 50])
     (let ([i (number->string j)])  
       (template i))))