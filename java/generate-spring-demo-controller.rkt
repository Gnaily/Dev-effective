#lang scribble/text
@(require  "../naming-style-conversion.rkt"
           "../date-util.rkt")

@(define-values (name-prefix swagger-anno-enable)
   (values "Demo" #t))
@(define var-name-prefix (camelcase->camelcase/lower name-prefix))
 
@list{
 /**
 * @"@"author yangliang <yangliang@"@"xx.com.cn>
 * @"@"date @(now-time-string)
 */
 @(if swagger-anno-enable @list{@"@"Api(tags = "...")} "")
 @"@"RestController
 @"@"RequestMapping("/...")
 public class @|name-prefix|Controller {

  private final @|name-prefix|Service @|var-name-prefix|Service;

  @"@"Autowired
  public @|name-prefix|Controller(@|name-prefix|Service @|var-name-prefix|Service) {
   this.@|var-name-prefix|Service = @|var-name-prefix|Service;
  }
 
  @(if swagger-anno-enable @list{@"@"Api(tags = "...")} "")
  @"@"PostMapping("/...")
  public Result<?> xx(@"@"RequestBody @"@"Valid @|name-prefix|Request request) {

   @|var-name-prefix|Service.name(request);
   return Result.success(null);
  }
 }
}