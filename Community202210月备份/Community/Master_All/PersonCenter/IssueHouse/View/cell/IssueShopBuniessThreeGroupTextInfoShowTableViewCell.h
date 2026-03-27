//
//  IssueShopBuniessThreeGroupTextInfoShowTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/22.
//

#import <UIKit/UIKit.h>
#import "IssueBaseThreeGroupTextInfoShowTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@protocol IssueShopBuniessThreeGroupTextInfoShowTableViewCellDelegate <NSObject>

- (void)shopBuniessTextInfoWithWidth:(NSString *)widthStr
                           withDepth:(NSString *)depthStr
                          withHeight:(NSString *)heightStr;

@end

@interface IssueShopBuniessThreeGroupTextInfoShowTableViewCell : IssueBaseThreeGroupTextInfoShowTableViewCell
@property (nonatomic,strong) UITextField *oneTextF;
@property (nonatomic,strong) UITextField *twoTextF;
@property (nonatomic,strong) UITextField *thrTextF;
@property (nonatomic,weak) id <IssueShopBuniessThreeGroupTextInfoShowTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
