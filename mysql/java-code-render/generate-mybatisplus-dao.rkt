#lang scribble/text
@(require  "../../date-util.rkt")

@define[name-common-prefix]{Test}

@list{
 /**
 * @"@"author yangliang <yangliang@"@"xx.com.cn>
 * @"@"date @(now-time-string)
 */
 @"@"Component
 public class  @|name-common-prefix|DAOImpl implements  @|name-common-prefix|DAO {

  private final  @|name-common-prefix|Mapper mapper;

  @"@"Autowired
  public  @|name-common-prefix|DAOImpl(@|name-common-prefix|Mapper mapper) {
   this.mapper = mapper;
  }

  //----------------------------------query----------------------------------------

  public  @|name-common-prefix| fetchOneById(Long id) {
   return mapper.lambdaQuery().eq(@|name-common-prefix|::getId, id).onlyOne();
  }

   
  public List<@|name-common-prefix|> listById(Long id) {
   return mapper.lambdaQuery()
   .eq(@|name-common-prefix|::getId, id)
   .list();
  }

  public List<@|name-common-prefix|> listByIds(List<Long> ids) {
   return mapper.lambdaQuery().in(@|name-common-prefix|::getId, ids).list();
  }

  //----------------------------------save------------------------------------------------

  public void save(@|name-common-prefix| entity) {
   mapper.save(entity);
  }

  public void saveBatch(List<@|name-common-prefix|> entities) {
   mapper.saveBatch(entities, entities.size());
  }

  public void saveOrUpdateById(@|name-common-prefix| entity) {
   mapper.saveOrUpdate(entity);
  }

  public void saveOrUpdateBatchById(List<@|name-common-prefix|> entities) {
   mapper.saveOrUpdateBatch(entities, entities.size());
  }

  //----------------------------------update----------------------------------------------
 
  public void updateById(@|name-common-prefix| entity) {
   mapper.updateById(entity);
  }

  public Boolean updateBatchById(List<@|name-common-prefix|> entities) {
   return mapper.updateBatchById(entities);
  }

  //----------------------------------updateStatus----------------------------------------

  public void updateStatus(Long id, YesOrNoEnum commonStatusEnum) {
   mapper.lambdaUpdate().set(@|name-common-prefix|::getStatus, commonStatusEnum.getCode())
   .eq( @|name-common-prefix|::getId, id)
   .update();
  }


  public void updateStatusBatch(List<Long> ids, YesOrNoEnum commonStatusEnum) {
   mapper.lambdaUpdate().set(@|name-common-prefix|::getStatus, commonStatusEnum.getCode())
   .in( @|name-common-prefix|::getId, ids)
   .update();
  }

  //----------------------------------remove----------------------------------------

  public void remove(Long id) {
   mapper.lambdaUpdate().eq(@|name-common-prefix|::getId, id).remove();
  }

  public void removeBatch(List<Long> ids) {
   mapper.lambdaUpdate().in(@|name-common-prefix|::getId, ids).remove();
  }

 }
}