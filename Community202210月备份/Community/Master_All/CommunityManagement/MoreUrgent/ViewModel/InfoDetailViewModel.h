//
//  InfoDetailViewModel.h
//  Community
//
//  Created by 余莹 on 2020/12/21.
//

#import <Foundation/Foundation.h>
#import "TopOrUregentInfoDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^InfoModelBlock)(NSDictionary *,BOOL);
@interface InfoDetailViewModel : NSObject
+ (void)getTopOrUrgentInfoDetailWithParms:(NSMutableDictionary *)parm WithModelBlock:(InfoModelBlock)modelBlock;
@end

NS_ASSUME_NONNULL_END
