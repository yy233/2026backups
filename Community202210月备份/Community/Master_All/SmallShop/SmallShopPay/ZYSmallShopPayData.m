//
//  ZYSmallShopPayData.m
//  Community
//
//  Created by ZY on 2022/3/26.
//

#import "ZYSmallShopPayData.h"
#import "ZYSmallShopPayModel.h"

@implementation ZYSmallShopPayData

// 微信支付
+ (void)weChatPayWithOrderNum:(NSString *)orderNum {
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"支付中..."];
    NSDictionary *params = @{@"orderNumber" : orderNum};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:ZY_BASEURL(kSmallShopPayUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    ZYSmallShopPayModel *model = [ZYSmallShopPayModel yy_modelWithJSON:responsObject];
                    PayReq *req = [[PayReq alloc] init];
                    req.openID = [TextShowWithModelStr textShowWithModelStr:model.appid];
                    req.nonceStr = [TextShowWithModelStr textShowWithModelStr:model.noncestr];
                    req.timeStamp = [[TextShowWithModelStr textShowWithModelStr:model.timestamp] intValue];
                    req.package = [TextShowWithModelStr textShowWithModelStr:model.package];
                    req.partnerId = [TextShowWithModelStr textShowWithModelStr:model.partnerid];
                    req.prepayId = [TextShowWithModelStr textShowWithModelStr:model.prepayid];
                    req.sign = [TextShowWithModelStr textShowWithModelStr:model.sign];
                    [[WeChatPayManager shareManager] hangleWechatPayWithPayReq:req];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

// 支付宝支付
+ (void)ZFBPayWithOrderNum:(NSString *)orderNum {
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"支付中..."];
    NSDictionary *params = @{@"orderNumber" : orderNum};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:ZY_BASEURL(kSmallShopPayUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    ZYSmallShopPayModel *model = [ZYSmallShopPayModel yy_modelWithJSON:responsObject];
                    NSString *zfbOrderStr = [TextShowWithModelStr textShowWithModelStr:model.orderStr];
                    [[ZfbPayManager shareManager] hangleZFPayOrderStr:zfbOrderStr];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

@end
