//
//  WebViewUseDataModel.h
//  Socialize
//
//  Created by 余莹 on 2023/6/5.
//

#import <Foundation/Foundation.h>
#import "LoginUseModel.h"
NS_ASSUME_NONNULL_BEGIN


//调用网页方法 window.methodRouter({event, data}),  网页数据上报数据格式 {id, status, message?, data?}

//1 主动上报。2回调
#define callBackTypeIs1Bool     ( ( model.callBackType == 1 ) ? YES : NO )
#define callBackTypeIs2Bool     ( ( model.callBackType == 2 ) ? YES : NO )


#pragma mark ================================================ sql sub
@interface MainDataSubParmObjModel : NSObject
@property (nonatomic,assign) NSInteger type; //0 delet 1 insert  2update 3查询select
@property (nonatomic,strong) NSArray * sql;//字符串数组
@property (nonatomic,strong) NSString *method;//数字类和dapp暂用
@property (nonatomic,assign) id value;//各种类型都有可能
@property (nonatomic,strong) NSString *to;//0830保活页背景判定使用

@end

#pragma mark ================================================ login sub old
@interface WebViewUseDataModelSubLoginUseResponseModel : NSObject
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,strong) LoginUseModel *result;
@end


#pragma mark ================================================ login mainsub 0713 result

@interface WebViewUseDataModel_LoginPersonalSign_Sub_resultData : NSObject

@property (nonatomic,strong) NSString *chainID;//固定参数
@property (nonatomic,strong) NSString *baseUrl;//固定url
@property (nonatomic,strong) NSString *message;//签名信息
@property (nonatomic,strong) NSString *address;//签名地址
@property (nonatomic,strong) NSString *signature;//签名结果
//1008审核状态不验证签名 直接登录
@property (nonatomic,assign) NSInteger isVerify;
@property (nonatomic,strong) NSDictionary *userData;
@end


#pragma mark ================================================  WebViewUseDataModel  main_sub
@interface WebViewUseDataModelSubDataModel : NSObject
//方法名字相关
@property (nonatomic,strong) NSString * method;
//sql相关
@property (nonatomic,strong) MainDataSubParmObjModel  *param;
//loginold
@property (nonatomic,strong) WebViewUseDataModelSubLoginUseResponseModel *response;

//基础
@property (nonatomic,strong) NSDictionary *error;
@property (nonatomic,strong) NSString * event;
@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic,assign) NSInteger status;//状态数据

//3dapp
@property (nonatomic,assign) BOOL collect;
@property (nonatomic,strong) NSString *url;

//页嘛层级
@property (nonatomic,assign) NSInteger pages;

@end

#pragma mark ================================================  WebViewUseDataModel


//@interface WebViewUseDataModel : NSObject
////{"callBackType":1, "packageName": "com.web3.chat.freeper","data":{"event":"fw@load-error","error":{}}}
////{"type":"1000"}
////1
//@property (nonatomic,assign) NSInteger callBackType;
//@property (nonatomic,strong) NSString *packageName;
//@property (nonatomic,strong) WebViewUseDataModelSubDataModel *data;
////login0713
//@property (nonatomic,strong) WebViewUseDataModel_LoginPersonalSign_Sub_resultData *result;
////2
//@property (nonatomic,assign) NSInteger type;
//@property (nonatomic,strong) NSString *locale;
//@property (nonatomic,assign) NSInteger status;
//
////3dapp
//@property (nonatomic,assign) BOOL collect;
//@property (nonatomic,strong) NSString *url;
//
////sql用的其他非data 非已经写过的通讯结构
//@property (nonatomic,strong) NSString *ID;//id
//@property (nonatomic,strong) NSString *refer;//发起方
//@property (nonatomic,strong) NSString *to;//接受方
//
//@end


@interface WebViewUseDataModel : NSObject
@property (nonatomic,strong) NSDictionary *error;

@property (nonatomic,strong) WebViewUseDataModelSubDataModel *data;
//login0713
@property (nonatomic,strong) WebViewUseDataModel_LoginPersonalSign_Sub_resultData *result;
//基础
/**
 1000 退出vc动作pop
 1001 语言切换 搭配locale
 1002 其他需要的初始 在1002处可以调用了
 1003 设置用户信息完成
 1004 DappUseBaseVc
 1006 跳直播主页list
*/
@property (nonatomic,assign) NSInteger type;//1000-100x用这个来分辨
@property (nonatomic,strong) NSString *locale;//语言切换
@property (nonatomic,assign) NSInteger status;//0成功，1失败
@property (nonatomic,strong) NSString *ID;//id
@property (nonatomic,strong) NSString *refer;//发起方
@property (nonatomic,strong) NSString *to;//接受方
//方法名字相关
@property (nonatomic,strong) NSString * method;//只有一层的ping result pong 红包personalSign
//dapp
@property (nonatomic,assign) BOOL collect;
@property (nonatomic,strong) NSString *url;

@end


#pragma mark ================================================  WebViewUseDataModel_sqlUse

@interface WebViewUseDataModel_sqlUse : NSObject
//sql用的主要接受转换model 部分键值区别于总model写过的通讯结构 单独一份
@property (nonatomic,strong) WebViewUseDataModelSubDataModel *data;
@property (nonatomic,strong) NSString *ID;//id
@property (nonatomic,strong) NSString *refer;//发起方
@property (nonatomic,strong) NSString *to;//接受方
@property (nonatomic,strong) NSString *type;
@end


#pragma mark ================================================  WebViewUseDataModel_dapplUse

@interface WebViewUseDataModel_dapplUse : NSObject
//sql用的主要接受转换model 部分键值区别于总model写过的通讯结构 单独一份
@property (nonatomic,strong) WebViewUseDataModelSubDataModel *data;
@property (nonatomic,strong) NSString *ID;//id
@property (nonatomic,strong) NSString *refer;//发起方
@property (nonatomic,strong) NSString *to;//接受方
@property (nonatomic,strong) NSString *type;
@end


 

NS_ASSUME_NONNULL_END
