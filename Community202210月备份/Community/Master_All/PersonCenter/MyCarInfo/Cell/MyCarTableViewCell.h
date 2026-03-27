//
//  MyCarTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EditActionBlock)(void);

@interface MyCarTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *rightPopShowBtn;
@property (nonatomic,copy)   EditActionBlock  editActionBlock;
@end

NS_ASSUME_NONNULL_END
