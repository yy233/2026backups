//
//  MyRepariShwoDetailUserInfoWithPhoneCallInfoTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import "MyRepariShwoDetailUserInfoWithTopUseTextTableViewCel.h"
#import "MyRepairShowDetailWorkOrderInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *MyRepariShwoDetailUserInfoWithPhoneCallInfoTableViewCell_I = @"MyRepariShwoDetailUserInfoWithPhoneCallInfoTableViewCell_I";

@interface MyRepariShwoDetailUserInfoWithPhoneCallInfoTableViewCel : MyRepariShwoDetailUserInfoWithTopUseTextTableViewCel
@property (nonatomic,strong) UIImageView *phoneCallImgV;
- (void)fillDetailVcModel:(MyRepairShowDetailWorkOrderInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
