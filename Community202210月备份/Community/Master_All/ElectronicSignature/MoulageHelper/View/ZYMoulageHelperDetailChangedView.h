//
//  ZYMoulageHelperDetailChangedView.h
//  Community
//
//  Created by ZY on 2021/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYMoulageHelperDetailChangedView : UIView

@property (weak, nonatomic) IBOutlet UIView *dropDownView;

@property (weak, nonatomic) IBOutlet UIView *contractTopView;

@property (weak, nonatomic) IBOutlet UIImageView *dropDownImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *nextView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIView *saveView;

@property (weak, nonatomic) IBOutlet UIButton *saveNewTemplateButton;

@property (weak, nonatomic) IBOutlet UIButton *saveTemplateButton;

@end

NS_ASSUME_NONNULL_END
