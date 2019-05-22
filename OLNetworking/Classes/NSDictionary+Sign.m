//
//  NSDictionary+Sign.m
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import "NSDictionary+Sign.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSString+Encrypt.h"
#import "NSDictionary+commonParms.h"

@implementation NSDictionary (Sign)

- (NSString *)generaterSignWithParameters{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary universalParametersWithOtherParameters:self]];
    // 1. 排序&拼接
    NSString *encryptString = [self sortedKeyOfParameters:params];
    // 2. URLEncode
    NSString *keyStringEncode = [encryptString basdk_stringURLEncode];
    NSString *keyStringEncode2 = [keyStringEncode basdk_rsa];
    
    NSLog(@"%@",keyStringEncode2);
    return keyStringEncode2;
}

- (NSMutableDictionary *)signParameters{
    NSMutableDictionary *selfDic = self.mutableCopy;
    NSString * timeStamp = [NSString stringWithFormat:@"%.f",[NSDate date].timeIntervalSince1970 * 1000];
    NSString * appid = @"44efec05494c4ca3a4a7ada47722a1a8";
    NSMutableDictionary * newDic = [[NSMutableDictionary alloc] initWithDictionary:self];
    [newDic setObject:timeStamp forKey:@"_timestamp"];
    [newDic setObject:appid forKey:@"_appid"];
    //    NSString * token = [[PGUserDefaultManager sharedManager] token];
    //    if (token && token.length > 0) {
    //        [newDic setObject:token forKey:@"token"];
    //    }
    NSString * sortParams = [selfDic sortedKeyOfParameters:newDic];
    NSString * sign = [selfDic sha1:sortParams];
    [selfDic setObject:timeStamp forKey:@"_timestamp"];
    [selfDic setObject:sign forKey:@"_sign"];
    //    if (token && token.length > 0) {
    //        [selfDic setObject:token forKey:@"token"];
    //    }
    return selfDic;
}

//sha1加密方式
- (NSString *)sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}


- (NSMutableDictionary *)encodedRsaparameters {
    NSMutableDictionary *params = @{}.mutableCopy;
    for (int i =0; i<self.allKeys.count; i++) {
        //        [params setObject:[[[NSString stringWithFormat:@"%@",self[self.allKeys[i]]] basdk_stringURLEncode] basdk_rsa] forKey:self.allKeys[i]];
        //不转码
        [params setObject:[[NSString stringWithFormat:@"%@",self[self.allKeys[i]]] basdk_rsa] forKey:self.allKeys[i]];
        
    }
    return params;
}

//针对GET 方法底层Request 被转码
- (NSMutableDictionary *)encodedParametersOfOtherHangZhouType
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:self];
    NSString *ctime = [NSString stringWithFormat:@"%.f",[NSDate date].timeIntervalSince1970 * 1000];
    [params setObject:ctime forKey:@"ctime"];
    
    // 生成sign
    NSString *sortedKey = [self sortedKeyOfParameters:params];
    NSString *keyStringEncode = [sortedKey basdk_stringURLEncode];
    NSString *keySHA256Encode = [keyStringEncode basdk_sha256];
    [params setObject:keySHA256Encode forKey:@"sign"];
    
    return params;
}

/*
 将字典用ASCII码顺序进行排列
 
 param = "\A\:\XXX\,\B\:\QQQ\"
 
 */
- (NSString *)dictTransformToJSONStringWithParameters:(NSDictionary *)parameters {
    if (parameters.allKeys.count == 0) {
        return @"{}";
    }
    
    NSArray *keys = [parameters.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSString *keyString = [NSString new];
    for (NSString *key in keys) {
        id value = [parameters objectForKey:key];
        NSString *keyAndValue = [NSString new];
        
        if ([value isKindOfClass:[NSString class]]) {
            keyAndValue = [NSString stringWithFormat:@"\"%@\":\"%@\",",key,value];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            keyAndValue = [NSString stringWithFormat:@"\"%@\":%@,",key,value];
        } else if ([value isKindOfClass:[NSArray class]]) {
            NSString *keyAndValueArray = @"[";
            for (NSDictionary *parameters in value)
            {
                keyAndValueArray = [keyAndValueArray stringByAppendingString:[NSString stringWithFormat:@"%@,",[self dictTransformToJSONStringWithParameters:parameters]]];
            }
            keyAndValueArray = [keyAndValueArray substringToIndex:keyAndValueArray.length - 1];
            keyAndValueArray = [keyAndValueArray stringByAppendingString:@"]"];
            
            keyAndValue = [NSString stringWithFormat:@"\"%@\":%@,",key,keyAndValueArray];
        }
        keyString = [keyString stringByAppendingString:keyAndValue];
    }
    return [NSString stringWithFormat:@"{%@}",[keyString substringToIndex:keyString.length - 1]];
}

/*
 将字典用ASICC码排序并且串起来
 
 param = "A=XXX&B=XXX&F=XXX"
 
 */
- (NSString *)sortedKeyOfParameters:(NSDictionary *)params {
    NSArray *keys = [params.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSString *keyString = [NSString new];
    for (NSString *key in keys) {
        id value = [params objectForKey:key];
        
        NSString *keyAndValue = nil;
        if ([value isKindOfClass:[NSArray class]]) {
            keyAndValue = [NSString stringWithFormat:@"%@=%@&",key,[value kc_orderJsonString]];
        }
        else {
            keyAndValue = [NSString stringWithFormat:@"%@=%@&",key,value];
        }
        keyString = [keyString stringByAppendingString:keyAndValue];
    }
    return [keyString substringToIndex:keyString.length - 1];
}

@end


@implementation NSArray (Sign)

- (NSString *)kc_orderJsonString {
    NSMutableString *jsonStr = [[NSMutableString alloc] initWithString:@"["];
    for (id object in self) {
        if ([object isKindOfClass:[NSArray class]]) {
            [jsonStr appendFormat:@"%@,",[object kc_orderJsonString]];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            [jsonStr appendFormat:@"%@,",[object kc_orderJsonString]];
        } else if ([object isKindOfClass:[NSNumber class]]) {
            [jsonStr appendFormat:@"%@,",object];
        } else if ([object isKindOfClass:[NSString class]]) {
            [jsonStr appendFormat:@"\"%@\",", object];
        }
    }
    if ([jsonStr hasSuffix:@","]) {
        [jsonStr deleteCharactersInRange:NSMakeRange(jsonStr.length-1, 1)];
    }
    
    [jsonStr appendFormat:@"]"];
    return jsonStr;
}

@end
