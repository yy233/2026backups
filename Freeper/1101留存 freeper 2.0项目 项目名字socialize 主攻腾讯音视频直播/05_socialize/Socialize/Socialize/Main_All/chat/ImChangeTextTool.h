//
//  ImChangeTextTool.h
//  Socialize
//
//  Created by 余莹 on 2023/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ImChangeTextUseContent_subParametersOrMyUser_Model : NSObject
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *nftId;
@property (nonatomic,strong) NSString *imId;
@property (nonatomic,strong) NSString *domain;
@property (nonatomic,strong) NSString *profileImageUrl;
@property (nonatomic,strong) NSString *receiveAddress;
@property (nonatomic,strong) NSString *ownerAddress;
 

 
@end

@interface ImChangeTextUseContentModel : NSObject
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *msg;
@property (nonatomic,assign) NSInteger contentIndex;
@property (nonatomic,strong) NSDictionary *parameters; //k title
@property (nonatomic,strong) NSDictionary *myUser;
@property (nonatomic,strong) NSDictionary *othersUser;
@property (nonatomic,strong) NSString *nftAddress;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,copy) NSString *detailsIdSSSS;//1:将NSString类型的修饰词改为copy形式


@end

@interface ImChangeTextUseMainModel : NSObject
@property (nonatomic,strong) ImChangeTextUseContentModel *content;
@property (nonatomic,strong) NSString *msgType;
@property (nonatomic,strong) NSString *from;
@end


@interface ImChangeTextTool : NSObject
//系统消息转形解析
+ (NSString *)changeImTextToolWithDic:(NSDictionary *)allDic;

@end

NS_ASSUME_NONNULL_END

//
//{\"category\":\"Activity\",\"contentIndex\":3,\"detailsId\":\"b602b4a9-82ec-4687-a6a6-e8f9da6dc696\",\"myUser\":{\"address\":\"0xf739dd7e0dc0c10f692b49f37586bdad2e1d9aa6\",\"domain\":\"\",\"imId\":\"upGyHPZqzz3SB\",\"profileImageUrl\":\"\"},\"othersUser\":{\"address\":\"0x864c3dd9ee6d3507cc734f72eff18fde5e278471\",\"domain\":\"0000620.free\",\"imId\":\"u7X0sD2t9G8R3\",\"profileImageUrl\":\"https://test.freeper.l-z.vip:61125/source//avatar/2023-07/5/1MrsaxX_1005_366_356775_gmi.png\"},\"parameters\":{\"title\":\"\U54c8\U54c8\U54c8\U54c8\U54c8\U597d\"},\"state\":3}
