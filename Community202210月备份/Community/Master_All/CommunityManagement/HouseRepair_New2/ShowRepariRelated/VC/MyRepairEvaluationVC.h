//
//  MyRepairEvaluationVC.h
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PopVcWithNeedUpDateBlock)(void);
@interface MyRepairEvaluationVC :  BaseViewController
@property (nonatomic, copy) PopVcWithNeedUpDateBlock popVcWithNeedUpDateBlock;
@property (nonatomic,assign) NSInteger thisEvalutionUseRepairID;
@property (nonatomic,assign) NSInteger commentStatusDraft;//1非常不满意 2不满意 3一般 4满意 5很满意
@property (nonatomic,strong) NSString *commentDraft;//草稿文本
@end

NS_ASSUME_NONNULL_END
