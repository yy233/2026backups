//
//  LifeCostPayMentListVcHeaderShaiXuanView.h
//  Community
//
//  Created by 余莹 on 2021/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LiftCost_PaymentRecords_HuHao, //户号
    LiftCost_PaymentRecords_Time,  //时间
} LiftCost_PaymentRecords;

@interface LifeCostPayMentListVcHeaderShaiXuanView : UIView
@property (nonatomic,assign) LiftCost_PaymentRecords viewType;
- (void)fillHuHaoListData:(NSMutableArray *)huhaoArr;
- (void)fillTimeListData:(NSMutableArray *)timeArr;

 

@end

NS_ASSUME_NONNULL_END
