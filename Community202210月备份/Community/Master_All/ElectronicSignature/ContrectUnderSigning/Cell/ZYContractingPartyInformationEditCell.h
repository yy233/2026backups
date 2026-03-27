//
//  ZYContractingPartyInformationEditCell.h
//  Community
//
//  Created by ZY on 2021/5/18.
//

#import <UIKit/UIKit.h>
#import "ZYContractingPartyInformationEditModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYContractingPartyInformationEditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *contentTF;

@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) ZYContractingPartyInformationEditModel *model;

@end

NS_ASSUME_NONNULL_END
