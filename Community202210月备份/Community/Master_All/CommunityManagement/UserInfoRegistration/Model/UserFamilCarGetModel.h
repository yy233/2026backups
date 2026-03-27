//
//  UserFamilCarGetModel.h
//  Community
//
//  Created by 余莹 on 2020/12/18.
//  家属详情页面 查询的时候 车辆数据 转换成carEntity时用

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserFamilCarGetModel : NSObject
@property (nonatomic,strong) NSString *carImgURL;//carImageUrl;
@property (nonatomic,strong) NSString *carId;//carPlate;
@property (nonatomic,assign) NSInteger carType;//code
@property (nonatomic,strong) NSString *carTypeName;//codename
@property (nonatomic,assign) NSInteger carPositionId;
@property (nonatomic,assign) NSInteger communityId;
//0305增
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,strong) NSString *carTypeText;
@property (nonatomic,strong) NSString *carPlate;
@property (nonatomic,strong) NSString *drivingLicenseUrl;


/** carId = "\U4eacA85620";
 carImgURL = "http://www.baidu.com/dsadsadadsa.jpg";
 carPosition = "<null>";
 carType = 2;
 checkStatus = 0;
 communityId = "<null>";
 createTime = "<null>";
 deleted = "<null>";
 id = 91;
 owner = "\U4f59\U67d0";
 phoneTel = 15914158051;
 uid = "<null>";
 updateTime = "<null>";
 */
@end

NS_ASSUME_NONNULL_END
