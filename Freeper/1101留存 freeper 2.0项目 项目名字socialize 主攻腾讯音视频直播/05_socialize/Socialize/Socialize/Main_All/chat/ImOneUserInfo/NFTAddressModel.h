//
//  NFTAddressModel.h
//  Socialize
//
//  Created by 余莹 on 2023/8/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NFTAddressModel : NSObject

@property (nonatomic,copy) NSString *symbol;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *contactAddress;
@property (nonatomic,copy) NSString *suffix;

/***
 "nftAddresses": [{
      "symbol": "FPE",
      "name": "Freeper",
      "contactAddress": "0x350d2f8e0b65f29a3fa3d8838744b2c1c5017960",
      "suffix": "free"
    }],
 
 
 */
@end

NS_ASSUME_NONNULL_END
