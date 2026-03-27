//
//  FenYouFreeIdInfoModel.h
//  Socialize
//
//  Created by 余莹 on 2023/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FenYouFreeIdInfoModel : NSObject

@property (nonatomic,copy) NSString *domain;
@property (nonatomic,copy) NSString *profileImageUrl;
@property (nonatomic,copy) NSString *createAddress;//创建者地址
@property (nonatomic,copy) NSString *ownerAddress;//拥有者地址
@property (nonatomic,copy) NSString *nftAddress;
@property (nonatomic,copy) NSString *nftId;
@property (nonatomic,copy) NSString *issueTypes;//NFT发行权益， 多个权益使用逗号隔开， 如： fans,friend
@property (nonatomic,assign) NSInteger state;//state  状态， 0、铸造， 1、售卖中， 2、流通， 3、销毁了, 6、已使用

@property (nonatomic,copy) NSString *address;//用户地址
@property (nonatomic,copy) NSString *imageUrl;//头像地址
@property (nonatomic,assign) CGFloat lastDealPrice;//最新成交价
@property (nonatomic,copy) NSString *lastDealSymbol;
@property (nonatomic,copy) NSString *lastDealDatetime;//最新成交时间
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *upLimit;//发行上限， 等于0时表示未发行
@property (nonatomic,copy) NSString *category;


//
@end

/**
 "createAddress": "0xa6671E26b79B3B2761ffF7989E3835C369D11E1D",
    "domain": "testDomain14.free",
    "id": 18,
    "imId": "ct-Dy0Po16l6bTqSZjiuvMcj",
    "introduction": "https://www.baidu.com/",
    "issueTypes": "",
    "lifeImages": "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Ftu1.whhost.net%2Fuploads%2F20190529%2F15%2F1559115560-nvpxfHCdIF.jpg&refer=http%3A%2F%2Ftu1.whhost.net&app=2002&size=f9999,https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.tt98.com%2Fd%2Ffile%2Fpic%2F2018102021071382%2F003.jpg&refer=http%3A%2F%2Fimg.tt98.com&app=2002&size=f9999",
    "nftId": 12350,
    "ownerAddress": "0xa6671E26b79B3B2761ffF7989E3835C369D11E1D",
    "profileImageUrl": "http://192.168.12.49:18080/im/2022-08/5/3amGkp4_78_86_2300_gmi.png",
    "rightsValue": "",
    "rowCreate": "2022-08-03 17:16:23",
    "rowUpdate": "2022-08-22 15:31:07",
    "state": 0,
    "username": "test14"
 
 
 
 address = 0x6c43dab3fb4d8078f79b55bb0c676f5aa53c1f22;
 category = friend;
 channelId = csPk6QsTuXWd;
 displayWeight = 99;
 domain = "111111.free";
 imageUrl = "https://test.freeper.l-z.vip:61125/source//nft/2023-06/20/4El45it_227_340_32883_gmi.jpg";
 isNoDisturb = 0;
 isShowUnreadCount = 1;
 lastDealDatetime = "2023-06-22 20:14:25";
 lastDealPrice = 1785230000000000000;
 lastDealSymbol = "F-U";
 nftId = 2601006;
 noticeCount = 0;
 saleCount = 7;
 status = 1;
 title = "哔哔赖赖的一天";
 type = 2;
 upLimit = 150;
 
 
 */

NS_ASSUME_NONNULL_END
