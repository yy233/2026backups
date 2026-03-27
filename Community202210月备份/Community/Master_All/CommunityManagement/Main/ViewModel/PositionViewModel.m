//
//  PositionViewModel.m
//  Community
//
//  Created by 余莹 on 2020/11/26.
//

#import "PositionViewModel.h"

@implementation PositionViewModel

+ (void)getCommunityInfoWithBlock:(MainGetCommunityInfoBlock)block{
    MainGetCommunityInfoBlock modelBlock = block;
    [PositionViewModel getNowPositionWithGetModelBlock:^(CommunityModel * model) {
        modelBlock(model);
    }];
}

+ (void)getNowPositionWithGetModelBlock:(MainGetCommunityInfoBlock)block{
    MainGetCommunityInfoBlock modelBlock = block;
    //只获取一次
     __block  BOOL isOnece = YES;
     __block CommunityModel *modelNil = [[CommunityModel alloc]init];
    modelNil.ID = 0;
    modelNil.detailAddress = @"";
    modelNil.name = @"";

     [NativePositioningManager getMoLocationWithSuccess:^(double lat, double lng){
         isOnece = NO;
         //只打印一次经纬度
         NSLog(@"lat lng (%f, %f)", lat, lng);
         lng = 29.6;
         lat = 106.0;//test
         //存储当前的经纬度
         [ShareUserInfo sharedUserInfo].userInfo.nowLatitude = lat;
         [ShareUserInfo sharedUserInfo].userInfo.nowLongitude = lng;

         if (!isOnece) {
             [NativePositioningManager stop];
//             isOnece = YES;
              [self getNewCommunityInfoWithLon:(double)lng AndLat:(double)lat WithModelBlock:^(CommunityModel * model) {
                  NSLog(@"getNewCommunityInfoWithLon === model.name %@",model.name);
                  modelNil = model;
                  modelBlock(model);
             }];
         }
     } Failure:^(NSError *error){
         isOnece = NO;
         NSLog(@"定位的getNowPositionWithGetModelBlock error = %@", error);
         if (!isOnece) {
             [NativePositioningManager stop];
         }
         modelBlock(modelNil);
     }];
}

+ (void)getNewCommunityInfoWithLon:(double)lng AndLat:(double)lat WithModelBlock:(MainGetCommunityInfoBlock)block{

    __block CommunityModel *model = [[CommunityModel alloc]init];
    MainGetCommunityInfoBlock modelBlock = block;

  //  NSLog(@"currentThread===a=,%@", [NSThread currentThread]);
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueue:URL_MAIN_CHOOSE_COMMUNITY_SEARCH_USE_LON_LAT
                                      withParams:@{@"lon":@(lng),@"lat":@(lat)}.mutableCopy
                                        finished:^(id responsObject, NSError *error) {
       // NSLog(@"currentThread===b=,%@", [NSThread currentThread]);

        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                modelBlock([CommunityModel mj_objectWithKeyValues:Y_ResponsObject_dataDic]);
            }else{
                modelBlock(model);
            }
        }else{
            modelBlock(model);
        }
    }];

}

@end
