//
//  MainAllTypeInformationListTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/9/4.
//

#import <UIKit/UIKit.h>
#import "TopInformationTableViewCell.h"
#import "MainAllTypeImInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainAllTypeInformationListTableViewCell : TopInformationTableViewCell
- (void)fillDataWithModel:(MainAllTypeImInfoModel*)model;
@end

NS_ASSUME_NONNULL_END
