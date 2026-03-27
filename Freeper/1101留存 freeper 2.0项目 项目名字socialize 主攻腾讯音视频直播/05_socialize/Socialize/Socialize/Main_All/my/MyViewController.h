//
//  MyViewController.h
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyViewController : Y_BaseViewController

@end


@interface MyTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titLabel;
@property (nonatomic,strong) UIImageView *rightIcon;


@end

NS_ASSUME_NONNULL_END
