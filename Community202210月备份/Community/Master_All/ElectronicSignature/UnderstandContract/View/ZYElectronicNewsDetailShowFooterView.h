//
//  ZYElectronicNewsDetailShowFooterView.h
//  Community
//
//  Created by ZY on 2021/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYElectronicNewsDetailShowFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *collectionButton;

@property (weak, nonatomic) IBOutlet UIButton *commentsButton;

@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

NS_ASSUME_NONNULL_END
