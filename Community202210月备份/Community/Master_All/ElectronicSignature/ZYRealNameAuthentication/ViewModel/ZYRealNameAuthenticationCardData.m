//
//  RealNameAuthenticationCardData.m
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import "ZYRealNameAuthenticationCardData.h"
/**
 
 //idCard/distinguish->/zhsj/base/api/real/IDCard/identification  1209 更换
     //type=  face正面  back反面
     //NSString *url = @"proprietor/user/idCard/distinguish";
     NSString *url = @"zhsj/base/api/real/IDCard/identification";
 */
@implementation ZYRealNameAuthenticationCardData
+ (void)getUserInfoWithImg:(UIImage *)cardImg withType:(UserCard_Type)type withModelBlock:(RealNameUserInfoModelBlock)cardUserInfoBlock{
    //type=  face正面  back反面
//    NSString *url = @"proprietor/user/idCard/distinguish";
    NSString *allLongUrl = [BASE_URL_OnlyAsOfPort stringByAppendingString:@"zhsj/base/api/real/IDCard/identification"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    switch (type) {
        case UserCard_Type_face:
            [params setValue:@"face" forKey:@"type"];
            break;
        case UserCard_Type_back:
            [params setValue:@"back" forKey:@"type"];
            break;
            
        default:
            break;
    }
    //压缩1.5以下
    UIImage *resultImage = cardImg;
    NSData * imageData = UIImageJPEGRepresentation(cardImg,1);
    NSUInteger lengthOfImg = [imageData length]/1000/1000;
    if (lengthOfImg > 1.5) {
        NSData *data = UIImageJPEGRepresentation(cardImg, lengthOfImg/1.5);//1.5m以下
        resultImage = [UIImage imageWithData:data];
    }
    //
    [SVProgressHUD showWithStatus:@"正在处理"];
    // YrequestPostImagesWithURL
    [[ToolOfNetWork sharedTools]YrequestPostImagesWithAllLongURL:allLongUrl withParams:params fileImgData:@[resultImage].mutableCopy fileNameStr:@"file" imgNameAllStr:@"身份证图片文件.png" finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        RealNameUserInfoModelBlock infoBlock = cardUserInfoBlock;
        RealNameAuthenticationCardModel *model = [[RealNameAuthenticationCardModel alloc]init];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                DLog(@"%@",responsObject);
                model = [RealNameAuthenticationCardModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                //block
                infoBlock(model,YES);
            }else{
                infoBlock(model,NO);
                Y_SVP_SHOW_ERR_MESSAGE;
            }
        }else{
            infoBlock(model,NO);
            Y_SVP_SHOW_ERR_DESCRIPTION;
        }
    }];
    
}
@end
