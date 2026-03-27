//
//  PersonInfoViewModel.m
//  Community
//
//  Created by 余莹 on 2021/3/29.
//

#import "PersonInfoViewModel.h"

@implementation PersonInfoViewModel
/**
 个人信息获取
 */
+ (void)getPersonUserInfoWithBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"proprietor/userdata/selectUserDataOne";
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
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
 上传头像
 */
+ (void)changePersonHeaderImgWithUpSendImg:(UIImage *)img withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //(1213更换接口)
    //NSString *url = @"proprietor/userdata/addAvatar";// //->/zhsj/base/api/file/up/load
    //[[ToolOfNetWork sharedTools]YrequestPostImagesWithURL:url withParams:@{}.mutableCopy fileImgData:@[img].mutableCopy fileNameStr:@"file" imgNameAllStr:@"headerImg.png" finished:^(id responsObject, NSError *error) {

    NSString *url = @"zhsj/base/api/file/up/load";
    NSString *allUrl = [BASE_URL_OnlyAsOfPort stringByAppendingString:url];
    [[ToolOfNetWork sharedTools]YrequestImgFileArrWithALLURL:allUrl withParams:@{}.mutableCopy fileDataArr:@[img].mutableCopy fileNameStr:@"file" finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = responsObject;//Y_ResponsObject_dataDic;
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
 更换昵称
 */
+ (void)changePersonNickNameWithStr:(NSString *)nickNameStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *nickN = [nickNameStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // [nickNameStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"proprietor/userdata/updateUserNickName?nickname=%@",nickN];
    
    [[ToolOfNetWork sharedTools]YrequestPutURLNoMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
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
 得到URL 更换头像
 */
+ (void)changePersonBirthdayTimeNameWithStr:(NSString *)birthdayTimeStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"proprietor/userdata/updateUserData";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:birthdayTimeStr forKey:@"birthdayTime"];
//    NSString *url = [NSString stringWithFormat:@"proprietor/userdata/updateUserData?birthdayTime=%@",birthdayTimeStr];
    [[ToolOfNetWork sharedTools]YrequestPutURLNoMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
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
 得到头像URL 处理头像URL数据
 */
+ (void)changePersonHeadImgWithUrlStr:(NSString *)imgUrlStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"proprietor/userdata/updateUserData";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:imgUrlStr forKey:@"avatarUrl"];
    [[ToolOfNetWork sharedTools]YrequestPutURLNoMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
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
