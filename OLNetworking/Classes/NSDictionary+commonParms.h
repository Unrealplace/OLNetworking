//
//  NSDictionary+commonParms.h
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (commonParms)

// 接口通用的参数
+ (NSDictionary *)universalParametersWithOtherParameters:(NSDictionary *)parameters;


@end

NS_ASSUME_NONNULL_END
