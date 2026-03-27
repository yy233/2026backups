//
//  RealNameAutgebtucationViewModel.m
//  Community
//
//  Created by 余莹 on 2021/3/9.
// 实名认证 人脸认证 接口部分

/** 1209 改
 
 idCard/distinguish->/zhsj/base/api/real/IDCard/identification
 realName/blink/init->/zhsj/base/api/real/blink/init
 realName/blink/result->/zhsj/base/api/real/blink/result
 */

#import "RealNameAuthenticationViewModel.h"

@interface RealNameAuthenticationViewModel ()
@property (nonatomic,strong) ZolozManager* zolozManager;
@end

@implementation RealNameAuthenticationViewModel

 
 singleton_implementation(realNameAuthenticationViewModelShare)
 
/**
 证件部分
 */
- (void)sendCerNo:(NSString *)cerNo andCerName:(NSString *)cerName andCerDetailAddress:(NSString *)cerAddress withUiVc:(UIViewController *)vc withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    
    // 初始化管理类
    self.zolozManager = [[ZolozManager alloc] initWithUIViewController:vc];
    // 认证初始化
    ZolozResult* zolozResult = [self.zolozManager authInit:nil certNo:cerNo cerName:cerName];
    if (zolozResult.code == ZOLOZ_SUCCESS) {
        // 发起认证初始化操作
        NSError *error;
        NSData *jsonData = [zolozResult.data dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        //__________________________init
        [self blinkInitWithGetXolosResultDic:dict andCerDetailAddress:cerAddress andZolozManager:self.zolozManager withDicBlock:^(NSDictionary * dic, BOOL success) {
            dicBlock(dic,success);
        }];
     
    }else{
        dicBlock(@{},NO);
    }
}

- (void)blinkInitWithGetXolosResultDic:(NSDictionary *)dict
                   andCerDetailAddress:(NSString *)cerAddress
                       andZolozManager:(ZolozManager *)zolozManager
                          withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *initUrl = @"zhsj/base/api/real/blink/init";
    NSString *allUrl = [BASE_URL_OnlyAsOfPort stringByAppendingString:initUrl];
    NSMutableDictionary *parms  = [[NSMutableDictionary alloc]init];
    [parms setValue:dict[@"platform"]       forKey: @"platform"];
    [parms setValue:dict[@"packageId"]      forKey:@"packageId"];
    [parms setValue:[dict[@"appName"] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]      forKey:@"packageName"];
    [parms setValue:dict[@"identityParam"]  forKey:@"identityParam"];
    [parms setValue:dict[@"metaInfo"]       forKey:@"metaInfo"];
    
    
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:initUrl withParams:parms finished:^(id responsObject, NSError *error) {
        if (responsObject != nil && [responsObject[@"code"] isEqualToString:@"0000"] ) { //0000

            NSData *data=[NSJSONSerialization dataWithJSONObject:responsObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *strOfInitRes=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"____________strOfInitRes   will auth  %@",strOfInitRes);
            //_________________________________auth人脸直接调用部分
//            [self cerFaceWithJsonStr:strOfInitRes andCerDetailAddress:cerAddress andZolozManager:zolozManager withDicBlock:^(NSDictionary * dic, BOOL success) {
//                dicBlock(dic,success);
//            }];
            //_________________________________auth人脸前回调
            dicBlock(responsObject,YES);
        }else{
            dicBlock(@{},NO);
        }
    }];
    
}
/**
 人脸部分
 */
- (void)willFaceCerWithResultDicJsonData:(NSString *)strOfInitRes andCerDetailAddress:(NSString *)cerAddress withUIVc:(UIViewController *)vc withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //用本管理类
    [self cerFaceWithJsonStr:strOfInitRes andCerDetailAddress:cerAddress andZolozManager:self.zolozManager withDicBlock:^(NSDictionary * dic, BOOL success) {
        dicBlock(dic,success);
    }];
    
}
- (void)cerFaceWithJsonStr:(NSString *)strOfInitRes
       andCerDetailAddress:(NSString *)cerAddress
           andZolozManager:(ZolozManager *)zolozManager
              withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    
    [zolozManager auth:strOfInitRes zolozCallback:^(ZolozResult *zolozResult) {
        if (zolozResult.code!=ZOLOZ_SUCCESS) {
             Y_SVP_SHOW_ERR_MES(@"认证失败");
            dicBlock(@{},NO);
            return;
        }else{
            Y_SVP_SHOW_SUCCESS_MES(@"认证完成");
            NSLog(@"zolozManager auth SUCCESS");
        }

        NSError *error;
        NSData *jsonData = [zolozResult.data dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSString * req = [NSString stringWithFormat:@"bizId=%@&certifyId=%@",[jsonDict objectForKey:@"bizid"],[jsonDict objectForKey:@"certifyId"]];
        //校验成功 从服务器获取认证结果
        NSLog(@"req---------%@",req);
        [self faceDataOkAndToDoResult:jsonDict  andCerDetailAddress:cerAddress withDicBlock:dicBlock];
    }];
    
}
- (void)faceDataOkAndToDoResult:(NSDictionary *)jsonDict
            andCerDetailAddress:(NSString *)cerAddress
                   withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //NSString *resUrl = @"proprietor/user/realName/blink/result";
    NSString *resUrl = @"zhsj/base/api/real/blink/result";
    NSString *allUrl = [BASE_URL_OnlyAsOfPort stringByAppendingString:resUrl];

    NSMutableDictionary *resParms = [[NSMutableDictionary alloc]init];
    [resParms setValue:[jsonDict objectForKey:@"bizid"]     forKey:@"bizId"];
    [resParms setValue:[jsonDict objectForKey:@"certifyId"]  forKey:@"certifyId"];
    [resParms setValue:cerAddress                   forKey:@"detailAddress"];// @"地址文本"

    [[ToolOfNetWork sharedTools] YrequestPostAllLongURLNoMainQueueWithBodyNotParms:allUrl  withBody:resParms finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);//successcode=0 拿到数据 不一定认证成功 内部 0000 成功 。4001 "业务异常 刷脸认证未完成。
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }

    }];
    
}
@end
