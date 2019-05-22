//
//  OLNetworkConfigure.m
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import "OLNetworkConfigure.h"

static NSString *const OLNetworkTypeKey = @"OLNetworkType";

@implementation OLNetworkConfigure

+ (void)configureNetworkType:(OLNetworkType)networkType {
    [[NSUserDefaults standardUserDefaults] setObject:@(networkType) forKey:OLNetworkTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (OLNetworkType)networkType {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:OLNetworkTypeKey] integerValue];
}

+ (NSString *)domainWithModuleType:(OLNetworkModuleType)moduleType {
    return [self domainWithNetworkType:[self networkType] moduleType:moduleType];
}

+ (NSString *)URLWithType:(OLURLType)type {
    OLNetworkModuleType moduleType = type / 1000;
    NSString *domain = [self domainWithNetworkType:[self networkType] moduleType:moduleType];
    return [NSString stringWithFormat:@"%@%@", domain, [self queryURLStringWithType:type]];
}

#pragma mark - Private Methods

+ (NSString *)domainWithNetworkType:(OLNetworkType)networkType moduleType:(OLNetworkModuleType)moduleType {
    switch (networkType) {
            //测试环境地址
            case OLNetworkTypeAlpha: {
                switch (moduleType) {
                        case OLNetworkModuleTypeAccountSystem:return @"http://192.168.5.70:8089";
                        case OLNetworkModuleTypeDefault:return @"http://192.168.5.70:8089";
                    default : return @"";
                }
                break;
            }
            case OLNetworkTypePre:{
                switch (moduleType) {
                        case OLNetworkModuleTypeAccountSystem:return @"https://pre-bmapi.qiekj.com";
                        case OLNetworkModuleTypeDefault:return @"http://192.168.5.70:8089";
                    default : return @"";
                }
                break;
            }
            // 正式环境地址
            case OLNetworkTypePublic: {
                switch (moduleType) {
                        case OLNetworkModuleTypeAccountSystem : return @"https://bmapi.qiekj.com";
                        case OLNetworkModuleTypeDefault:return @"http://192.168.5.70:8089";
                    default : return @"";
                }
                
                break;
            }
            
    }
    return @"";
}

+ (NSString *)queryURLStringWithType:(OLURLType)type {
    switch (type) {
            case OLURLTypeLogin:return @"/operator/login";
        default:
            return @"";
            break;
    }
}

@end
