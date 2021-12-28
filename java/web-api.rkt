#lang racket
(provide
 (struct-out api)
 define-api-group)

(require (for-syntax syntax/parse))

(define-struct api (name desc path in out) #:transparent)

(define-syntax (define-api-group stx)
  (syntax-parse stx
    [(_ (~var id id) ( (~seq [(~var name id)
                              (~or (~var desc id)
                                   (~var desc str))
                              
                              (~or (~var path id)
                                   (~var path str))
                              (~var in id)
                              (~var out id)] ...) ))
     #'(define id (list (api(tostring (syntax-e (syntax name)))
                            (tostring (syntax-e (syntax desc)))
                            (tostring (syntax-e (syntax path)))
                            (tostring (syntax-e (syntax in)))
                            (tostring (syntax-e (syntax out)))) ...))]))

(define (tostring stx)
  (cond [(symbol? stx) (symbol->string stx)]
        [(string? stx) stx]))

(module+ test
  (require rackunit)
  (define-api-group user-api ([get-user 查询用户 "/user/get" GetUser empty]
                              [add-user 添加用户 "/user/add" AddUser User]))
  (check-equal? user-api (list
                          (api
                           "get-user"
                           "查询用户"
                           "/user/get"
                           "GetUser"
                           "empty")
                          (api
                           "add-user"
                           "添加用户"
                           "/user/add"
                           "AddUser"
                           "User"))))
