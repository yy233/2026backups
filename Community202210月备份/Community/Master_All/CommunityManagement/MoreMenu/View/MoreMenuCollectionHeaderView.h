//
//  UIViewMoreMenuCollectionHeaderView.h
//  Community
//
//  Created by 余莹 on 2020/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreMenuCollectionHeaderView : UIView
@property (nonatomic,strong) UILabel *titleLabel;
- (void)headerTitleTest:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
