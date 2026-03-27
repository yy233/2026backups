//
//  ZolozVerify.h
//  esand_ios_demo
//
//  Created by eSandInfo on 2018/7/2.
//  Copyright © 2018年 esandinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZolozResult.h"
#import <UIKit/UIViewController.h>
#import "ZolozCommon.h"
#import "ZolozResult.h"

/**
 * 可信身份认证管理类
 */
@interface ZolozManager : NSObject

/**
 * 初始化函数
 * @param vc 视图控制器
 */
- (id)initWithUIViewController:(UIViewController *)vc;

/**
  * 初始化
  * @param businessId 业务ID, 可为空
  * @param certNo 身份证号
  * @param cerName 姓名
  * @return 初始化报文，格式如下：
  <pre>
  {
      "identityParam":"", -- 认证数据
      "appName":"", -- APP名称
      "platform":"", -- 平台：Android/IOS
      "metaInfo":"", -- META INFO
      "appSign":"", -- APP 签名
      "bizId":"", -- 业务Id
      "packageName":"" -- 包名
  }
  </pre>
  */
- (ZolozResult*) authInit:(NSString*)businessId certNo:(NSString*)certNo cerName: (NSString*) cerName;

/**
  * 发起认证操作，认证成功后自动扣费.
  * @param initMsg 服务器端返回的初始化报文
  * @param zolozCallback 回调类,回调传入参数为对象result，result包括如下几个字段：
  <pre>
  {
      "success":true,
      "message":"{"bizid":"20201019173432663b87e5cd1c5eb45e","certifyId":"3d8ae79ab266cb92809e35c52d26d095"}", -- 执行结果，未必是json字符串
      "code":"ZOLOZ_SUCCESS",
      "data":"{"bizid":"20201019173432663b87e5cd1c5eb45e","certifyId":"3d8ae79ab266cb92809e35c52d26d095"}" -- 执行结果，为空后者json字符串
  }
  </pre>
  */
- (void) auth:(NSString *)initMsg zolozCallback:(ZolozCallback) zolozCallback;

@end
