//
//  LifeCostMyCostModel.h
//  Community
//
//  Created by 余莹 on 2021/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostMyCostModel : NSObject
@property (nonatomic,strong) NSString *address;
@property (nonatomic,assign) NSInteger groupId;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,assign) NSInteger companyId;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,assign) NSInteger familyId;
@property (nonatomic,strong) NSString *familyName;
@property (nonatomic,assign) NSInteger typeID;
@property (nonatomic,strong) NSString *typeName;
//图地址
@property (nonatomic,strong) NSString *largeSizeIcon;
@property (nonatomic,strong) NSString *mediumIcon;
@property (nonatomic,strong) NSString *icon;

 
@end
/**
  
 address = "纵横世纪";
 companyId = 13;
 companyName = "重庆燃气集团公司";
 familyId = 154613516;
 familyName = GG;
 groupId = 32987447495364608;
 groupName = "我家";
 icon = "https://i.postimg.cc/HsS1xc91/3.png";
 largeSizeIcon = "https://i.postimg.cc/25wggjd2/a3.png";
 mediumIcon = "https://i.postimg.cc/bYSK8ym3/q3.png";
 typeId = 3;
 typeName = "燃气费";
}
 */
NS_ASSUME_NONNULL_END
