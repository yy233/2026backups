//
//  PayOrderMoneyInPutTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/1/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PayOrderMoneyInPutTableViewCellDelegate <NSObject>

- (void)touchMoneyNumBtnWithMoneyStr:(NSString *)moneyStr;

@end

@interface PayOrderMoneyInPutTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView *lineV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *leftL;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIView *lineVCenter;
@property (nonatomic,strong) UIView *subMoneyNumBtnsBackView;

@property (nonatomic,weak) id <PayOrderMoneyInPutTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
