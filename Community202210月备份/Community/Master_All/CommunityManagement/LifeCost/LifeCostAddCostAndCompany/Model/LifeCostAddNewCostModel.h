//
//  LifeCostAddNewCostModel.h
//  Community
//
//  Created by 余莹 on 2021/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostAddNewCostModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *largeSizeIcon;
@property (nonatomic,strong) NSString *mediumIcon;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger id;
/**
 
 -------
 createTime = "2020-12-11 11:16:53";
 deleted = 0;
 icon = "https://i.postimg.cc/XYQqnYpr/1.png";
 id = 1;
 largeSizeIcon = "https://i.postimg.cc/s2rRt0kD/a1.png";
 mediumIcon = "https://i.postimg.cc/zGFsMxxN/q1.png";
 name = "\U6c34\U8d39";
 */
@end

NS_ASSUME_NONNULL_END
