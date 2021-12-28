#lang scribble/text
@(require
   "../naming-style-conversion.rkt"
   "web-api.rkt")

@(define (render-as-rest-class name desc basepath api-list)
   @list{
 /**
 * @"@"author yangliang <yangliang@"@"xx.com.cn>
 */
 @"@"Api(tags = "@|desc|")
 @"@"RestController
 @"@"RequestMapping("@|basepath|")
 public class @|name|Controller{
  @(map spring-web-api api-list)
 }
 })

@(define (render-as-service-class name desc api-list)
   @list{
 /**
 * @"@"author yangliang <yangliang@"@"xx.com.cn>
 */
 @"@"Service
 public class @|name|Service{
  @(map (λ (e) (spring-web-api-inf e #f)) api-list)
 }
 })

@(define (render-as-rest-interface name-prefix desc basepath api-list)

   @list{
 /**
 * @|desc|
 * @"@"author yangliang <yangliang@"@"xx.com.cn>
 */
 @"@"RequestMapping("@|basepath|")
 public interface @|name-prefix|ControllerInf {
  @(map (λ (e) (spring-web-api-inf e #t))  api-list )
 }
 })

@(define (render-as-service-interface name-prefix desc api-list)
   @list{
 /**
 * @|desc|
 * @"@"author yangliang <yangliang@"@"xx.com.cn>
 */
 public interface @|name-prefix|ServiceInf {
  @(map (λ (e) (spring-web-api-inf e #f))  api-list )
 }
 })

@(define (spring-web-api api)
   @let[([id (snakecase->camelcase/lower (string-replace (api-name api) "-" "_"))]
         [desc (api-desc api)]
         [path (api-path api)]
         [in (api-in api)]
         [out (api-out api)])
        @list{

         @"@"ApiOperation("@|desc|")
         @"@"PostMapping("@|path|")
         public Result<@|out|Vo> @|id|(@"@"RequestBody @"@"Valid @|in|Request request) {

          return null;
         }

         }])


@(define (spring-web-api-inf api add-web-anno)
   @let[([id (snakecase->camelcase/lower (string-replace (api-name api) "-" "_"))]
         [desc (api-desc api)]
         [path (api-path api)]
         [in (api-in api)]
         [out (api-out api)])
        @list{
              
         /**
         *  
         * @|desc| 
         * @"@"param request 参数对象
         * @"@"return 结果对象
         */
         @(when add-web-anno @list{@"@"PostMapping("@|path|")@"\n"})@;
         @|out|Vo @|id|(@(when add-web-anno @list{@"@"RequestBody @"@"Valid}) @|in|Request request);

         }])

@;;;;;;;;;;;;;;render as markdown;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

@(define (render-as-markdown api-list)
   @(define (markdown-item a-api)
      @list{- @(api-desc a-api)(@(api-path a-api)) @"\n"})
   @(map markdown-item api-list))


@(module+ main
   
   (define-api-group user-api ([add-user 添加用户 /user/add AddUser User]
                               [get-user 查询用户 /user/get GetUser User]
                               [list-user 查询用户列表 /user/list ListUser UserList]
                               [remove-user 删除用户 /user/remove RemoveUser empty]))
   
   (render-as-markdown user-api)
   (render-as-rest-interface "User" "用户接口" "/api/v1/" user-api)
   (render-as-rest-class "User" "用户接口" "/api/v1/" user-api)
   (render-as-service-interface "User" "用户接口"  user-api)
   (render-as-service-class "User" "用户接口"  user-api)
   @;{(out (render-as-class "User" "用户接口" "/api/v1/" user-api) "C:/Users/Gnaily/sowftware-dev/company/code-repo/wzl-bff-boss/src/main/java/com/kezhilian/wzl/bff/boss/coupon/controller/UserController.java")} )