//
//  CommunityChooseTableViewController.h
//  Community
//
//  Created by 余莹 on 2020/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunityChooseTableViewController : BaseChooseTableViewController
@property (nonatomic,strong) CommunityModel *comunityMode;
@property (nonatomic,strong) CityChooseModel *cityModel;
@property (nonatomic,strong) NSString *searchTextStr;
@end

NS_ASSUME_NONNULL_END
