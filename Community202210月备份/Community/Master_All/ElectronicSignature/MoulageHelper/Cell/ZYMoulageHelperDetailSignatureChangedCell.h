//
//  ZYMoulageHelperDetailSignatureChangedCell.h
//  Community
//
//  Created by ZY on 2021/5/8.
//

#import <UIKit/UIKit.h>
#import "ZYZhangManagerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYMoulageHelperDetailSignatureChangedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *signatureView;

@property (weak, nonatomic) IBOutlet UIImageView *signatureImageView;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (nonatomic, strong) ZYZhangManagerDataModel *model;

@end

NS_ASSUME_NONNULL_END
