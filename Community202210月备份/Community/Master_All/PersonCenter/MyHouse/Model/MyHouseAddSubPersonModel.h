//
//  MyHouseAddSubPersonModel.h
//  Community
//
//  Created by 余莹 on 2021/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHouseAddSubPersonModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,assign) NSInteger relation;//关系 6 7
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger houseId;
@end

NS_ASSUME_NONNULL_END
