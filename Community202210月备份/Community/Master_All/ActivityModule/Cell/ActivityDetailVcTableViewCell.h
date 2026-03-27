//
//  ActivityDetailVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/6/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



static NSString *ActivityDetailVcOwnUserInfoTableViewCell_I = @"ActivityDetailVcOwnUserInfoTableViewCell";
static NSString *ActivityDetailVcLongTextTableViewCell_I = @"ActivityDetailVcLongTextTableViewCell";
static NSString *ActivityDetailVcWrangLongTextTableViewCell_I = @"ActivityDetailVcWrangLongTextTableViewCell";
static NSString *ActivityDetailVcAddressAndTimeTableViewCell_I = @"ActivityDetailVcAddressAndTimeTableViewCell";
static NSString *ActivityDetailVcMianInfoTableViewCell_I = @"ActivityDetailVcMianInfoTableViewCell";
@interface ActivityDetailVcTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *titleL;
@end

//个人信息
@interface ActivityDetailVcOwnUserInfoTableViewCell : ActivityDetailVcTableViewCell
@property (nonatomic,strong) LabelYu *nameL;
@property (nonatomic,strong) LabelYu *phoneL;
@end

//活动信息 长文本
@interface ActivityDetailVcLongTextTableViewCell : ActivityDetailVcTableViewCell
@property (nonatomic,strong) UILabel *lonTextL;
@end

//活动须知警告
@interface ActivityDetailVcWrangLongTextTableViewCell : ActivityDetailVcLongTextTableViewCell
@property (nonatomic,strong) UIButton *wrongTopBtn;
@end

//地址时间
@interface ActivityDetailVcAddressAndTimeTableViewCell : ActivityDetailVcTableViewCell
@property (nonatomic,strong) UILabel * addressL;
@property (nonatomic,strong) UILabel * timeFillFromL;
@property (nonatomic,strong) UILabel * timeActiveBeginL;
@end

//主办方
@interface ActivityDetailVcMianInfoTableViewCell : ActivityDetailVcTableViewCell
@property (nonatomic,strong) UILabel * mainAddressL;
@property (nonatomic,strong) UILabel * phoneTitleL;
@property (nonatomic,strong) UIButton *phoneConentBtn;
@property (nonatomic,strong) UIButton *addressConentBtn;

@end


NS_ASSUME_NONNULL_END
