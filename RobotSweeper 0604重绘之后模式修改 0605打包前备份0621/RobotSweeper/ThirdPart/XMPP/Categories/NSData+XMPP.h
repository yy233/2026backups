#import <Foundation/Foundation.h>

@interface NSData (XMPP)

- (NSData *)md5Digest;

- (NSData *)sha1Digest;

- (NSString *)hexStringValue;

- (NSString *)base64Encoded;
- (NSData *)base64Decoded;
@end

#ifndef XMPP_EXCLUDE_DEPRECATED

#define XMPP_DEPRECATED($message) __attribute__((deprecated($message)))

@interface NSData (XMPPDeprecated)
- (NSData *)md5Digest XMPP_DEPRECATED("Use -md5Digest");
- (NSData *)sha1Digest XMPP_DEPRECATED("Use -xmpp_sha1Digest");
- (NSString *)hexStringValue XMPP_DEPRECATED("Use -xmpp_hexStringValue");
- (NSString *)base64Encoded XMPP_DEPRECATED("Use -xmpp_base64Encoded");
- (NSData *)base64Decoded XMPP_DEPRECATED("Use -xmpp_base64Decoded");
@end

#undef XMPP_DEPRECATED

#endif
