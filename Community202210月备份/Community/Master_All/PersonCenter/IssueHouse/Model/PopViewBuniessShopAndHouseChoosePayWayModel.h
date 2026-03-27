//
//  PopViewBuniessShopAndHouseChoosePayWayModel.h
//  Community
//
//  Created by 余莹 on 2021/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN 

@interface PopViewBuniessShopAndHouseChoosePayWayModel : NSObject
@property (nonatomic,strong) NSString *annotation;
@property (nonatomic,strong) NSString *houseConstName;
@property (nonatomic,assign) NSInteger houseConstCode;//所有的常量相关 上传时的ID 是传code
@property (nonatomic,assign) NSInteger houseConstType;
@property (nonatomic,assign) NSInteger id;
/**
 {
                 "id": 1,
                 "houseConstCode": 1,//248
                 "houseConstName": "押1付1",
                 "houseConstType": "1",
                 "annotation": "租房押金"
             },
 */
@end

NS_ASSUME_NONNULL_END
