//
//  NSString+Encrypt.h
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Encrypt)

// URLEncode编码
- (NSString *)basdk_stringURLEncode;

// SHA256加密
- (NSString *)basdk_sha256;

// AES-128加密,作用于手机
- (NSString *)basdk_aes128String;
- (NSString *)basdk_aes128Decrypt;

// MD5加密
- (NSString *)basdk_md5;
// RSA 加密
- (NSString *)basdk_rsa;

@end

NS_ASSUME_NONNULL_END
