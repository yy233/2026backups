//
//  ZYZhangDrawView.h
//  Community
//
//  Created by ZY on 2021/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYZhangDrawView : UIView

@property (weak, nonatomic) IBOutlet UIView *drawView;

@property (weak, nonatomic) IBOutlet UIView *toolView;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet UIButton *blackButton;

@property (weak, nonatomic) IBOutlet UIButton *redButton;

@property (weak, nonatomic) IBOutlet UIButton *greenButton;

@property (weak, nonatomic) IBOutlet UIButton *thickThinButton;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@end

NS_ASSUME_NONNULL_END
