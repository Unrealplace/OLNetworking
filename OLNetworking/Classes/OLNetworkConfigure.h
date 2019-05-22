//
//  OLNetworkConfigure.h
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,OLNetworkType) {
    // 测试环境
    OLNetworkTypeAlpha,
    // 正式环境
    OLNetworkTypePublic,
    // 预发环境
    OLNetworkTypePre,
};

typedef NS_ENUM(NSInteger,OLNetworkModuleType) {
    
    //账号系统
    OLNetworkModuleTypeAccountSystem = 1,
    
    //默认的域名
    OLNetworkModuleTypeDefault = 999,
    
};

typedef NS_ENUM(NSInteger,OLURLType) {
    
  OLURLTypeLogin = 1000,
    
};

@interface OLNetworkConfigure : NSObject

/**
 配置网络环境
 
 @param networkType 网络环境类型
 */
+ (void)configureNetworkType:(OLNetworkType)networkType;

/**
 获取当前的网络环境
 
 @return 网络环境类型
 */
+ (OLNetworkType)networkType;

/**
 获取特定模块的域名
 
 @param moduleType 模块类型
 @return 模块的域名
 */
+ (NSString *)domainWithModuleType:(OLNetworkModuleType)moduleType;

/**
 获取特定接口的url
 
 @param type 接口类型
 @return 接口的url
 */
+ (NSString *)URLWithType:(OLURLType)type;

@end

NS_ASSUME_NONNULL_END
