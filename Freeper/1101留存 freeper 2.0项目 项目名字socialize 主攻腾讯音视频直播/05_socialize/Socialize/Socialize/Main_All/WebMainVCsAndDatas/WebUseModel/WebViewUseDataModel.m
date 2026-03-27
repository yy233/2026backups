//
//  WebViewUseDataModel.m
//  Socialize
//
//  Created by 余莹 on 2023/6/5.
//

#import "WebViewUseDataModel.h"



/**
 web接受主DataModel相关
 */
#pragma mark ================================================  WebViewUseDataModel  main_sub

@implementation WebViewUseDataModelSubDataModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"response":[WebViewUseDataModelSubLoginUseResponseModel class],
        @"param":[MainDataSubParmObjModel class],
    };
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end

#pragma mark ================================================  WebViewUseDataModel

@implementation WebViewUseDataModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data" : [WebViewUseDataModelSubDataModel class],
             @"result":[WebViewUseDataModel_LoginPersonalSign_Sub_resultData class]

    };
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end


/**
 登录相关
 */


#pragma mark ================================================ login sub old
@implementation WebViewUseDataModelSubLoginUseResponseModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data" : [LoginUseModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}


@end

#pragma mark ================================================ login mainsub 0713 result
@implementation WebViewUseDataModel_LoginPersonalSign_Sub_resultData

@end
 

/**
 通讯sql相关
 */
#pragma mark ================================================  WebViewUseDataModel_sqlUse sub
@implementation MainDataSubParmObjModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end

#pragma mark ================================================  WebViewUseDataModel_sqlUse
//sql用的主要接受转换model 部分键值区别于总model写过的通讯结构 单独一份
@implementation WebViewUseDataModel_sqlUse


+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data" : [WebViewUseDataModelSubDataModel class],
             
    };
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end


#pragma mark ================================================  WebViewUseDataModel_dapplUse
 
@implementation WebViewUseDataModel_dapplUse

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data" : [WebViewUseDataModelSubDataModel class],
             
    };
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end

#pragma mark ========= 


