//
//  EIntergralMallMingXiListVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EIntergralMallMingXiListVcTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *numL;
- (void)fillCellWithTypeIsZhiChu:(BOOL)isZhiChu
                   withTittleStr:(NSString*)titleStr
                     withTimeStr:(NSString*)timeStr
                      withNumStr:(NSString*)numStr;
@end

NS_ASSUME_NONNULL_END
