//
//  HistoryHolderTableViewCell.h
//  Socialize
//
//  Created by 余莹 on 2023/5/16.
//

#import <UIKit/UIKit.h>
//#import "MyLayout.h"

static NSString * _Nonnull HistoryHolderTableViewCell_I = @"HistoryHolderTableViewCell";
NS_ASSUME_NONNULL_BEGIN

@interface HistoryHolderTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *bkView;
@property (nonatomic,strong) UIImageView *imgv;
@property (nonatomic,strong) UILabel *typeL;
@property (nonatomic,strong) UIView *centerLineV;
@property (nonatomic,strong) UILabel *nickOrIdL;
@property (nonatomic,strong) UILabel *timeTitleL;
@property (nonatomic,strong) UILabel *timeCountL;
 
@end

NS_ASSUME_NONNULL_END
