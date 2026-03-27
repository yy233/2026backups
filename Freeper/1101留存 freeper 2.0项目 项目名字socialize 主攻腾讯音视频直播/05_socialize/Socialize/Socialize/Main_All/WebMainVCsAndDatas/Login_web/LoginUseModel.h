//
//  LoginUseModel.h
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//

#import <Foundation/Foundation.h>
//#import "WebViewUseDataModel.h"
@class WebViewUseDataModel_LoginPersonalSign_Sub_resultData;
NS_ASSUME_NONNULL_BEGIN

@interface LoginUseModel : NSObject
/**
 essageHandler Body:{"callBackType":2, "packageName": "com.web3.chat.freeper","data":{"id":"123456789","status":200,"data":

 {"address":"0x33d8796ce9e83fc0e4acc2e1271d8906e35e7603","signatureMessage":"Welcome to Freeper!\n\nClick to sign in and accept the Freeper Terms of Service: https://freeper.io/tos\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x33d8796ce9e83fc0e4acc2e1271d8906e35e7603\n\nNonce:\n8277ad94-2710-4ea5-9489-353de87b4a4b","signature":"0x86757c44665678a7ff1d2dfaae68de896dade6db61ed7daf47c55a8f16e34f2832e116ae20f037972eadc2035e7112692750fe58b2020b9f0e8181ea4bda71ee1b"}
 }}
 0x86757c44665678a7ff1d2dfaae68de896dade6db61ed7daf47c55a8f16e34f2832e116ae20f037972eadc2035e7112692750fe58b2020b9f0e8181ea4bda71ee1b
 */
//+ (void)loginVerifySignatureWithInfo:(LoginUseModel *)model withBlock:(BaseDicAndSuccessBoolBlock)block;

@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * signatureMessage;
@property (nonatomic,strong) NSString * signature;
 

+ (void)loginVerifySignatureWithResultModel:(WebViewUseDataModel_LoginPersonalSign_Sub_resultData *)model withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)checkVerifySignaturewithBlock:(BaseDicAndSuccessBoolBlock)block;//用户address 查询其他信息

+ (void)userImid:(NSString *)imidStr checkAddressAndOtherInfoWithBlock:(BaseDicAndSuccessBoolBlock)block;//用户imid 查询其他信息
+ (void)userAddress:(NSString *)address checkImidAndOtherInfoWithBlock:(BaseDicAndSuccessBoolBlock)block;//用户address 查询其他信息


@end

NS_ASSUME_NONNULL_END
