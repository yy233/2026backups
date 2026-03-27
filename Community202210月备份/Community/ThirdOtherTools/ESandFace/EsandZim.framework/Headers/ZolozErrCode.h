//
//  ZolozErrCode.h
//  esand_ios_demo
//
//  Created by ReidLee on 2019/6/26.
//  Copyright © 2019 esandinfo. All rights reserved.
//

#ifndef ZolozErrCode_h
#define ZolozErrCode_h

/**
 * 错误码枚举
 */
typedef enum {
    /**
     * 执行成功
     */
    ZOLOZ_SUCCESS,
    /**
     * 执行失败
     */
    ZOLOZ_FAILED,
    /**
     * 未知错误
     */
    ZOLOZ_UNKNOW_ERR,
    /**
     * 本地代码执行抛异常
     */
    ZOLOZ_CLIENT_ERROR,
    /**
     * 系统错误
     */
    ZOLOZ_SYSTEM_ERROR,
    /**
     * 执行流程已经被用户主动取消
     */
    ZOLOZ_CANCEL,
    /**
     * 网络异常
     */
    ZOLOZ_NETWORK_ERROR,
    /**
     * 服务器端返回的数据异常
     */
    ZOLOZ_SERVER_ERROR
} ZolozErrCode;

#endif /* ZolozErrCode_h */
