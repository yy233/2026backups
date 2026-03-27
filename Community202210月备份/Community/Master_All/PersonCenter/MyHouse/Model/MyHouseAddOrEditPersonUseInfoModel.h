//
//  MyHouseAddOrEditPersonUseInfoModel.h
//  Community
//
//  Created by 余莹 on 2022/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHouseAddOrEditPersonUseInfoModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *mobile;//手机
@property (nonatomic,strong) NSString *idCard;//身份证
@property (nonatomic,assign) NSInteger relation;//关系 6 7
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger houseId;
@property (nonatomic,strong) NSString *faceUrl;//人脸
@property (nonatomic,assign) NSInteger carePattern;//是否关怀模式
@property (nonatomic,assign) NSInteger faceAndIdcardInfoAuditStatu;//关怀模式提交后的身份证相关审核状态


@end

NS_ASSUME_NONNULL_END
