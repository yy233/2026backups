//
//  ZhiBoListViewModel.h
//  Socialize
//
//  Created by 余莹 on 2023/5/26.
//

#import <Foundation/Foundation.h>
 
#define  data_records_Key                   @"records"

NS_ASSUME_NONNULL_BEGIN

@interface ZhiBoListViewModel : BaseDataViewModel
@property (nonatomic,strong) NSMutableArray *saveOldArrChangeNewArr;
 
@end



@interface ZhiBoShowInfoModel : NSObject  <NSCopying,NSMutableCopying,NSSecureCoding>
@property (nonatomic,assign) NSInteger transHash;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,assign) NSInteger isSignUp;
@property (nonatomic,assign) NSInteger createConsumeAmount;
@property (nonatomic,assign) NSInteger category;
@property (nonatomic,assign) NSInteger applicants;
@property (nonatomic,assign) NSInteger admissionFee;

@property (nonatomic,copy) NSString *transHash_T;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *startDatetime;
@property (nonatomic,copy) NSString *recode;
@property (nonatomic,copy) NSString *picture;
@property (nonatomic,copy) NSString *domain;
@property (nonatomic,copy) NSString *description_D;
@property (nonatomic,copy) NSString *createConsumeSymbol;
@property (nonatomic,copy) NSString *categoryTitle;
@property (nonatomic,copy) NSString *categoryNo;
@property (nonatomic,copy) NSString *admissionSymbol;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *activityId;//活动id
@property (nonatomic,copy) NSString *roomId;//id//房间id
//@property (nonatomic,assign) NSInteger roomIdInt;//id//房间id

@property (nonatomic,copy) NSString *daoJiShiUseTimeIv;

@end
NS_ASSUME_NONNULL_END
