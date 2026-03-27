//
//  RecommendPinLunTableViewCell.h
//  Socialize
//
//  Created by 余莹 on 2023/5/16.
//

#import <UIKit/UIKit.h>
#import "RecommendDetailPinLunModel.h"
#import "MyLayout.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecommendPinLunTableViewCell : UITableViewCell

@property(nonatomic, strong) UIView *bkv;
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UILabel     *nickNameLabel;
@property(nonatomic, strong) UILabel     *textMessageLabel;
//@property(nonatomic, strong) cellSubIdTimeStartAllView *subv;


//对于需要动态评估高度的UITableViewCell来说可以把布局视图暴露出来。用于高度评估和边界线处理。以及事件处理的设置。
@property(nonatomic, strong, readonly) MyBaseLayout *rootLayout;
- (void)setModellll:(RecommendDetailPinLunModel *)plunModel;
@end

NS_ASSUME_NONNULL_END
