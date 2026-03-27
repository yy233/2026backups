//
//  ZYProcessEvidenceCell.h
//  Community
//
//  Created by ZY on 2021/5/28.
//

#import <UIKit/UIKit.h>
#import "ZYProcessEvidenceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYProcessEvidenceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *partView;

@property (weak, nonatomic) IBOutlet UIButton *telButton;

@property (nonatomic, strong) ZYProcessEvidenceDataListDataModel *model;

@end

NS_ASSUME_NONNULL_END
