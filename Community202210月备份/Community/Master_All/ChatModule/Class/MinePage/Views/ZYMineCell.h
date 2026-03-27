//
//  ZYMineCell.h
//  Community
//
//  Created by ZY on 2021/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYMineCell : UITableViewCell

// 收藏视图
@property (weak, nonatomic) IBOutlet UIView *collectionView;

// 相册视图
@property (weak, nonatomic) IBOutlet UIView *photoAlbumView;

// 卡包视图
@property (weak, nonatomic) IBOutlet UIView *cardView;

// 表情视图
@property (weak, nonatomic) IBOutlet UIView *emojView;

// 我的文件视图
@property (weak, nonatomic) IBOutlet UIView *fileView;

@property (weak, nonatomic) IBOutlet UILabel *fileNumLabel;

// 我的动态视图
@property (weak, nonatomic) IBOutlet UIView *mineDynamicView;

// 系统设置视图
@property (weak, nonatomic) IBOutlet UIView *systemSettingsView;

@property (weak, nonatomic) IBOutlet UILabel *systemSettingsNumLabel;

// 帮助中心视图
@property (weak, nonatomic) IBOutlet UIView *helpCenterView;

@end

NS_ASSUME_NONNULL_END
