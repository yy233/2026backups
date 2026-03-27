//
//  ZolozCommon.h
//  esand_ios_demo
//
//  Created by eSandInfo on 2018/8/14.
//  Copyright © 2018年 esandinfo. All rights reserved.
//

#ifndef ZolozCommon_h
#define ZolozCommon_h
#import "ZolozResult.h"
/**
 * 客户端平台
 */
#define PLATFORM @"IOS"
/**
 回调代码块定义
 @param zolozResult 执行结果 `ZolozResult`
 */
typedef void (^ZolozCallback)(ZolozResult* zolozResult);

#endif /* ZolozCommon_h */
