//
//  ZiXunInfoTableViewCell.h
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import <UIKit/UIKit.h>

static NSString * _Nonnull ZiXunInfoTableViewCell_I = @"ZiXunInfoTableViewCell";
#import "Mylayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZiXunInfoTableViewCell : UITableViewCell
@property(nonatomic, strong) UIView *bkv;
@property(nonatomic, strong) UILabel     *textMessageLabel;
@property(nonatomic, strong) UIImageView *zhankaiBtn;
@property(nonatomic, strong) UILabel     *timeL;

//对于需要动态评估高度的UITableViewCell来说可以把布局视图暴露出来。用于高度评估和边界线处理。以及事件处理的设置。
@property(nonatomic, strong, readonly) MyBaseLayout *rootLayout;
//- (void)setModellll:(Model *)infoModel;
@end

NS_ASSUME_NONNULL_END
