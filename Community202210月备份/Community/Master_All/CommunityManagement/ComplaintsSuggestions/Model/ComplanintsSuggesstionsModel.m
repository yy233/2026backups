//
//  ComplanintsSuggesstionsModel.m
//  Community
//
//  Created by 余莹 on 2021/3/30.
//

#import "ComplanintsSuggesstionsModel.h"

@implementation ComplanintsSuggesstionsModel
+ (void)sendCompanintsImgWithImg:(UIImage *)img withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
//    complainImages
    [[ToolOfNetWork sharedTools]YrequestPostImagesWithURL:URL_ComplaintsSuggestions_Send_Img withParams:@{}.mutableCopy  fileImgData:@[img].mutableCopy  fileNameStr:@"complainImages" imgNameAllStr:@"complainImages.png" finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
//                block(Y_ResponsObject_dataDic,YES);
                block(responsObject,YES);
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
+ (void)sendAllCompanintParmsWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_ComplaintsSuggestions_Send_All withParams:parms finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(@{},YES);
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
