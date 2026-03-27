//
//  ThridTIXianChongZhiData.m
//  Community
//
//  Created by 余莹 on 2021/12/20.
//

#import "ThridTIXianChongZhiData.h"

@implementation ThridTIXianChongZhiData
 
#pragma mark - 加载用户余额提现至微信数据
+ (void)tiXianToWechatWithMoneyAmount:(NSString *)amountStr withPatPassword:(NSString *)payPasswordStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSDictionary *parms = @{@"amount" : amountStr, @"payPassword" : payPasswordStr};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Post_WeChat_Withdrawal] withBody:parms finished:^(id responsObject, NSError *error) {
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

/**
 ZYWalletWithdrawalModel *model = [ZYWalletWithdrawalModel yy_modelWithJSON:Y_ResponsObject_dataDic];
 if (model.success) {
     NSString *msg;
     if (self.type == TiXianAndChongZhi_Type_tixian) {
         msg = @"提现成功";
     }else if (self.type == TiXianAndChongZhi_Type_chognzhi) {
         msg = @"充值成功";
     }
     [ZYProgressHUDTool showCustomHUDTextMessage:msg toView:self.view.window];
     [self popVC];
 }else {
     [SVProgressHUD showErrorCustomHUDWithStatus:model.msg delay:3.0];
 }
 */

#pragma mark - 加载用户余额提现至支付宝数据

+ (void)tiXianToZFBWithMoneyAmount:(NSString *)amountStr withPatPassword:(NSString *)payPasswordStr withBlock:(BaseDicAndSuccessBoolBlock)block{

    NSDictionary *parms = @{@"amount" : amountStr, @"payPassword" :  payPasswordStr};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Post_Alipay_Withdrawal] withBody:parms finished:^(id responsObject, NSError *error) {
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
//        [self.view endEditing:YES];
//        [self.payPasswordInputView clearText];
//        self.payPasswordInputView.hidden = YES;
//        if (isNotNil(responsObject)) {
//            if (Y_IS_Success) {
//                ZYWalletWithdrawalModel *model = [ZYWalletWithdrawalModel yy_modelWithJSON:Y_ResponsObject_dataDic];
//                if (model.success) {
//                    NSString *msg;
//                    if (self.type == TiXianAndChongZhi_Type_tixian) {
//                        msg = @"提现成功";
//                    }else if (self.type == TiXianAndChongZhi_Type_chognzhi) {
//                        msg = @"充值成功";
//                    }
//                    [ZYProgressHUDTool showCustomHUDTextMessage:msg toView:self.view.window];
//                    [self popVC];
//                }else {
//                    [SVProgressHUD showErrorCustomHUDWithStatus:model.msg delay:3.0];
//                }
//            }else {
//                [self.payPasswordInputView clearText];
//                self.payPWStr = @"";
//                Y_SVP_SHOW_ERR_MESSAGE
//            }
//        }else {
//            [self.payPasswordInputView clearText];
//            self.payPWStr = @"";
//            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
    }];
}
@end
