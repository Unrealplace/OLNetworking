//
//  NSDictionary+Sign.h
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Sign)

//RSA加密
- (NSMutableDictionary *)encodedRsaparameters;
// Multipart Data拼接参数的时候，AF会将字典拆成多个参数，需要做处理
- (NSString *)dictTransformToJSONStringWithParameters:(NSDictionary *)parameters;
//签名加密
- (NSMutableDictionary *)signParameters;
@end


@interface NSArray (Sign)

- (NSString *)kc_orderJsonString;

@end

NS_ASSUME_NONNULL_END
