//
//  AccompanyFooterView.h
//  Community
//
//  Created by 余莹 on 2020/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccompanyFooterView : BaseTableViewFooterView
@property (nonatomic,strong) UIButton *deletBtn;
@property (nonatomic,strong) UIButton *moreChooseAddbtn;
//普通状态 ui
- (void)isNomalNoMoreChooseTypeFooterView;
//多选状态 ui
- (void)isMoreChooseTypeFooterView;
@end

NS_ASSUME_NONNULL_END
