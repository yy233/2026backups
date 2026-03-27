//
//  OrderAdviceData.m
//  Community
//
//  Created by 余莹 on 2022/3/14.
//

#import "OrderAdviceData.h"


static NSString *Order_AdviceInput_Imgs_Url = @"file/fileInfo/uploadGetUrls2";   //提交订单反馈
static NSString *Order_AdviceInput_Info_Url = @"feedback/insertFeedback";   //提交订单反馈

@implementation OrderAdviceData
//订单反馈图片上传
+ (void)smallOrderAdviceImg:(NSMutableArray *)imgsArr withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *shopFileUpImgALLUrl = [NSString stringWithFormat:@"%@%@%@", BASE_URL_OnlyAsOfPort,@"shop/",Order_AdviceInput_Imgs_Url];
    [[ToolOfNetWork sharedTools]YrequestPostImagesWithAllLongURL:shopFileUpImgALLUrl withParams:@{@"type":@"store"}.mutableCopy fileImgData:imgsArr fileNameStr:@"file" imgNameAllStr:@"store.png" finished:^(id responsObject, NSError *error) {
        
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
        
    }];
}
+ (void)smallOrderAdviceInfo:(NSMutableDictionary *)infoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
     
    [[ToolOfNetWork sharedTools]YrequestPostAllLongURLNoMainQueueWithBodyNotParms:Y_SmallShop_URL_AllLongURL(Order_AdviceInput_Info_Url) withBody:infoDic finished:^(id responsObject, NSError *error) {
        /**
         code = 0;
         data = 1503272377380032513;
         message = "新增意见反馈成功！";
         */
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
    }];
    
    
}
@end
