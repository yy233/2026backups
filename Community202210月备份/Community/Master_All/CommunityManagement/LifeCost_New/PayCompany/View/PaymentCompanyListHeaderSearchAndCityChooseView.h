//
//  PaymentCompanyListHeaderSearchAndCityChooseView.h
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentCompanyListHeaderSearchAndCityChooseView : UIView
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIButton *cityChangeBtn;
- (void)fillHeaderCellCityNameWithStr:(NSString *)cityName;
@end

NS_ASSUME_NONNULL_END
