//
//  IssueAddPhotoViewModel.m
//  Community
//
//  Created by 余莹 on 2021/2/26.
//

#import "IssueAddPhotoViewModel.h"
//商铺的
#define  Url_HeaderImgs         @"lease/shop/uploadHeadImg"
#define  Url_MiddleImgs         @"lease/shop/uploadMiddleImg"
#define  Url_OtherImgs          @"lease/shop/uploadOtherImg"
//房屋类型的
#define  Url_OwnerHouseImages  @"lease/house/ownerHouseImages"
 


@implementation IssueAddPhotoViewModel
+ (void)issueAddBuniessPhotosWithHeadImgs:(NSMutableArray *)headImgs
                           withMiddleImgs:(NSMutableArray *)middeImgs
                            withOtherImgs:(NSMutableArray *)otherImgs
                                    block:(BaseDicAndSuccessBoolBlock)imgUrlBlock{
   
    __block  BaseDicAndSuccessBoolBlock block = imgUrlBlock;
    __block  NSInteger countEndType = 0;
    __block  NSMutableDictionary *imgsDic = [[NSMutableDictionary alloc]init];
    [self getShopHeadWithHeadImgs:headImgs withListBlocl:^(NSArray * arr) {
        [imgsDic setValue:arr forKey:@"H"];
        //
        countEndType+=1;
        if (countEndType==3) {
            block(imgsDic,YES);
        }
    }];
    [self getShopMiddleWithMiddleImgs:middeImgs withArr:^(NSArray * arr) {
        [imgsDic setValue:arr forKey:@"M"];
        //
        countEndType+=1;
        if (countEndType==3) {
            block(imgsDic,YES);
        }
    }];
    [self getShopOtherWithOtherImgs:otherImgs withArr:^(NSArray * arr) {
        [imgsDic setValue:arr forKey:@"O"];
        //
        countEndType+=1;
        if (countEndType==3) {
            block(imgsDic,YES);
        }
    }];
    
}

+ (void)getShopHeadWithHeadImgs:(NSMutableArray *)headImgs  withListBlocl:(BaseListArrBlock)list{
    [[ToolOfNetWork sharedTools]YrequestPostImagesWithURL:Url_HeaderImgs  withParams:@{}.copy  fileImgData:headImgs  fileNameStr:@"file"  imgNameAllStr:@"header.png"  finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            BaseListArrBlock block = list;
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    block(Y_ResponsObject_dataArr);
                }else{
                    block(@[]);
                }
            }else{
                block(@[]);
            }
        });
        
    }];
}
+ (void)getShopMiddleWithMiddleImgs:(NSMutableArray *)middeImgs withArr:(BaseListArrBlock)list{
    [[ToolOfNetWork sharedTools]YrequestPostImagesWithURL:Url_MiddleImgs  withParams:@{}.copy  fileImgData:middeImgs  fileNameStr:@"file"  imgNameAllStr:@"midde.png"  finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BaseListArrBlock block = list;
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    block(Y_ResponsObject_dataArr);
                }else{
                    block(@[]);
                }
            }else{
                block(@[]);
            }
        });
       
    }];
}
+ (void)getShopOtherWithOtherImgs:(NSMutableArray *)otherImgs withArr:(BaseListArrBlock)list{
    [[ToolOfNetWork sharedTools]YrequestPostImagesWithURL:Url_OtherImgs  withParams:@{}.copy  fileImgData:otherImgs  fileNameStr:@"file"  imgNameAllStr:@"other.png"  finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BaseListArrBlock block = list;
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    block(Y_ResponsObject_dataArr);
                }else{
                    block(@[]);
                }
            }else{
                block(@[]);
            }
        });
      
    }];
}

#pragma mark == 房屋类型的
+ (void)issueAddHousePhotosWithAllImgs:(NSMutableArray *)allImgs
                                 block:(BaseListArrAndSuccessBoolBlock)imgUrlListBlock{
    [[ToolOfNetWork sharedTools]YrequestPostImagesWithURL:Url_OwnerHouseImages  withParams:@{}.copy  fileImgData:allImgs  fileNameStr:@"houseImages"  imgNameAllStr:@"houseImages.png"  finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BaseListArrAndSuccessBoolBlock block = imgUrlListBlock;
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    block(Y_ResponsObject_dataArr,YES);
                }else{
                    block(@[],NO);
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
      
    }];
    
    
}
@end
