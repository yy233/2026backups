//
//  MyHeaderView.h
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headimg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *idInfo;
@property (weak, nonatomic) IBOutlet UIButton *idInfoTopBtn;
@property (weak, nonatomic) IBOutlet UIButton *headimgTopBtn;



+ (MyHeaderView *)instaceThisViewSelf;
@end

NS_ASSUME_NONNULL_END
