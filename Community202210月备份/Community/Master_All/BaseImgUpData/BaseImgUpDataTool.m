//
//  BaseImgUpDataTool.m
//  Community
//
//  Created by 余莹 on 2022/4/26.
//

#import "BaseImgUpDataTool.h"

@implementation BaseImgUpDataTool
+ (void)baseUpImgWithOneImg:(UIImage *)phototImg withParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSLog(@"公共图片上传接口 %@",phototImg);
    NSString *url = @"zhsj/base/api/file/up/load";
    NSString *allUrl = [BASE_URL_OnlyAsOfPort stringByAppendingString:url];
    [[ToolOfNetWork sharedTools]YrequestImgFileArrWithALLURL:allUrl withParams:parms fileDataArr:@[phototImg].mutableCopy fileNameStr:@"file" finished:^(id responsObject, NSError *error) {
         if (isNotNil(responsObject)) {
             if (isNotNil(responsObject)) {
                 if (Y_IS_Success) {
                     NSDictionary *dic = Y_ResponsObject_dataDic;
                     block(dic,YES);
                 }else{
                     block(@{},NO);
                     Y_SVP_SHOW_ERR_MESSAGE
                 }
             }else{
                 block(@{},NO);
                 Y_SVP_SHOW_ERR_DESCRIPTION
             }
         }
    }];
 
}
@end
