//
//  PubNetwork.m
//  Socialize
//
//  Created by 余莹 on 2023/5/29.
//

#import "PubNetwork.h"

static NSString *pub_SnedImg_Sub_Url = @"/file/upload";
static NSString *pub_ImgUse_DataArrKey = @"data";
static NSString *pub_ImgUse_DataSubUrlKey = @"url";
@implementation PubNetwork

+ (void)pub_sendImgWithOneImgObj:(UIImage *)willSendImg withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    
    [[Y_NetWorkBaseTool sharedTool] YrequestImgFileArrNotOtherInfoWithALLURL: Y_AllURL_FileUpLoad(pub_SnedImg_Sub_Url) imgFileDataArr:@[willSendImg].mutableCopy fileNameStr:@"pub_imge_file0" finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSMutableArray *getArrs  = Y_ResponsObject_dataArr;
                block(getArrs.firstObject,YES);
                
            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
}



+ (void)pub_sendImgWithOneImgObj:(UIImage *)willSendImg andParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block{
    [[Y_NetWorkBaseTool sharedTool] YrequestImgFileArrWithALLURL:Y_AllURL_FileUpLoad(pub_SnedImg_Sub_Url) withParams:parms fileDataArr:@[willSendImg].mutableCopy fileNameStr:@"pub_imge_file1" finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {

        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSMutableArray *getArrs  = Y_ResponsObject_dataArr;
                block(getArrs.firstObject,YES);
                
            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
}
+ (void)pub_sendImgWithImgObjArr:(NSMutableArray *)arr withBlock:(BaseDicAndSuccessBoolBlock)block{
    [[Y_NetWorkBaseTool sharedTool] YrequestImgFileArrNotOtherInfoWithALLURL:Y_AllURL_FileUpLoad(pub_SnedImg_Sub_Url) imgFileDataArr:arr fileNameStr:@"pub_imge_file_name" finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSMutableArray *getArrs  = Y_ResponsObject_dataArr;
                block(getArrs,YES);
                
            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
}
@end
