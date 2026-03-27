//
//  PrivacyAgreementUserAgreementModel.h
//  Community
//
//  Created by 余莹 on 2022/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllAgreementUseModel : NSObject
//详情用
@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSString *content;
//同意相关使用的键值
@property (nonatomic,strong) NSString *notice;
@property (nonatomic,strong) NSArray *typeList;
//
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger ID;


@end

NS_ASSUME_NONNULL_END
