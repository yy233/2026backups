//
//  ZhiBoBaseNetTools.h
//  Socialize
//
//  Created by 余莹 on 2023/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZhiBoBaseInfo : NSObject
 
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *picture;
//@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *startDatetime;
@property (nonatomic,strong) NSString *categoryTitle;
@property (nonatomic,strong) NSString *categoryNo;
//@property (nonatomic,strong) NSString *createConsumeAmount;
//@property (nonatomic,strong) NSString *createConsumeSymbol;
//@property (nonatomic,strong) NSString *admissionFee;
//@property (nonatomic,strong) NSString *admissionSymbol;
@property (nonatomic,strong) NSString *recode;
@end

@interface ZhiBoBaseNetTools : NSObject
+ (void)insertActivityData:(ZhiBoBaseInfo *)zhiBoBaseInfo WithBlock:(BaseDicAndSuccessBoolBlock)block;//新增待播直播 多个属性定
+ (void)changeActivityStateParms:(NSDictionary *)parms withBlock:( void (^)(BOOL isSuccessChange,NSDictionary *dataDic) )block;//主播做当前活动状态更改
+ (void)oneLookerBaoMinOneActivityWithParms:(NSDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block;//观众报名
//activity_auth_updateActivitybiabin 更改房间名字
+ (void)oneActivityInfoChangeWithParms:(NSDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block;

@end

NS_ASSUME_NONNULL_END
