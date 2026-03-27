//
//  ElectronicSignatureNewsTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/26.
//

#import <UIKit/UIKit.h>
#import "ZYContractKnowledgeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ElectronicSignatureNewsTableViewCell : UITableViewCell

- (void)showCellWithDic:(NSMutableDictionary *)dataSourceDic;

@property (nonatomic, strong) ZYContractKnowledgeListDataListModel *model;

@end

NS_ASSUME_NONNULL_END
