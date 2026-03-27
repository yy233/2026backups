//
//  ZYAddFriendsTopCell.h
//  Community
//
//  Created by ZY on 2021/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYAddFriendsTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *uidLabel;

@property (weak, nonatomic) IBOutlet UIImageView *qcodeImageView;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (nonatomic,strong) UIButton *scanTouchBtn;
@end

NS_ASSUME_NONNULL_END
