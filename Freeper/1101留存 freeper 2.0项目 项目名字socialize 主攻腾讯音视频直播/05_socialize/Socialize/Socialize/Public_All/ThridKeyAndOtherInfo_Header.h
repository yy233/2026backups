//
//  ThridKeyAndOtherInfo_Header.h
//  Socialize
//
//  Created by 余莹 on 2023/5/27.
//

#ifndef ThridKeyAndOtherInfo_Header_h
#define ThridKeyAndOtherInfo_Header_h

#import "ShareUserInfo.h"


/**
 腾讯SDKAppID
 */
#if (type_urlset_now == type_url_prod)
#define SDKAppID  1400777437  //正式环境的
#define TXpush_ID 40139

#elif (type_urlset_now == type_url_test)
#define SDKAppID 1400773174  //测试的
#define TXpush_ID 40140
#else
#define SDKAppID 1400773174  //测试的
#define TXpush_ID 40140
#endif

//#define public_SECRETKEY @"396a9c3ed48af0947f19038f3c167943a5436d04089aa9d8f4f67e4887d0bd2d"

//#define IM_userID @"dev001"
//#define IM_sig @"eJwtzF0LgjAUxvHvsuuwc9zcTOhiIBIkVBjURTfp1jj0Nswkir57pl4*vwf*H7bNi6C1NUtYGACb9JuMvTV0op6NbQFwfB7mfPSeDEtQACjFUYnhsS9Pte08iqIQAAZt6Po3GXMVz4TiY4VcF145lxYhLsnrfQ5y87xXu0wvUhSYle-1YWoqWZC-ZK7Wc-b9ATVlMPM_"



//正式环境的
//#define SDKAppID 1400777437
//#define public_SECRETKEY @"396a9c3ed48af0947f19038f3c167943a5436d04089aa9d8f4f67e4887d0bd2d"//私有的
 



//#define IM_userID   ([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"")
//#define IM_sig      ([ShareUserInfo share].userInfo.imSignature.length > 0 ? [ShareUserInfo share].userInfo.imSignature : @"")


//static NSString *IM_userID = ([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"");
//static NSString *IM_sig = ([ShareUserInfo share].userInfo.imSignature.length > 0 ? [ShareUserInfo share].userInfo.imSignature : @"");
 
#endif /* ThridKeyAndOtherInfo_Header_h */
