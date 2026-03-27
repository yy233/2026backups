//
//  ChatWithSystemInfoTableViewCell.h
//  Socialize
//
//  Created by 余莹 on 2023/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *ChatWithSystemInfoTableViewCell_I = @"ChatWithSystemInfoTableViewCell";
@interface ChatWithSystemInfoTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *contentL;
@property (nonatomic,strong) UIButton *rightBottomBtn;
@end

NS_ASSUME_NONNULL_END
