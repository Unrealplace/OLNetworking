//
//  NSDictionary+commonParms.m
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import "NSDictionary+commonParms.h"

@implementation NSDictionary (commonParms)

+ (NSDictionary *)universalParametersWithOtherParameters:(NSDictionary *)parameters
{
    //    NSString *ctime = [NSString stringWithFormat:@"%.f",[NSDate date].timeIntervalSince1970 * 1000];
    //    NSMutableDictionary *params = [NSMutableDictionary new];
    //    [params setObject:@"ios" forKey:@"osType"];
    //    [params setObject:@"kids_camera_iphone" forKey:@"appName"];
    //    [params setObject:@"1.0.0" forKey:@"version"];
    //    [params setObject:@(ctime.intValue) forKey:@"ctime"];
    //    [params setObject:@"0" forKey:@"isEnc"];
    //    [params setObject:[UIDevice adUnion_idfa] forKey:@"deviceMark"];
    //
    //    if (parameters)
    //    {
    //        [params addEntriesFromDictionary:parameters];
    //    }
    return parameters;
}


@end
