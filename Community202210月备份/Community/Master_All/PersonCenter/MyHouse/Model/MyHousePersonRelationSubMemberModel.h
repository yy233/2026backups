//
//  MyHousePersonRelationSubMemberModel.h
//  Community
//
//  Created by 余莹 on 2021/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHousePersonRelationSubMemberModel : NSObject
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *relationText;
@property (nonatomic,assign) NSInteger relation;
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,strong) NSString *avatarUrl;
@property (nonatomic,strong) NSString *faceUrl;//人脸数据
@property (nonatomic,assign) NSInteger carePattern;//是否关怀模式
@property (nonatomic,assign) NSInteger examineStatus;//关怀人脸身份证的审核状态 0.同步中 1.成功 2.失败

/**
 members =         (
                 {
         id = 91304220183105536;
         mobile = 15023576859;
         name = "张无忌";
         relation = 6;
         relationText = "亲属";
     },
 
 //租客7 家属6
 */
@end

NS_ASSUME_NONNULL_END
