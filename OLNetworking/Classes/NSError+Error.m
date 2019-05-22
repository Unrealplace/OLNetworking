//
//  NSError+Error.m
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import "NSError+Error.h"

@implementation NSError (Error)

- (NSString *)errorString
{
    NSInteger code = self.code;
    if ([self.userInfo objectForKey:@"error"]) {
        NSString *errorMsg = [self.userInfo objectForKey:@"error"];
        if (errorMsg) {
            return errorMsg;
        }
    }
    if (code == -1003 || code == -1005 || code == -1004 || code == -1007 || code==-1011) {
        return @"服务器开小差,稍候再试试吧";
    }else if (code == -1009){
        return @"网络异常,请检查网络设置";
    }else if (code == -1001){
        return @"连接超时,请检查网络设置";
    }
    
    return nil;
}


+ (NSError *)errorWithString:(NSString *)errorString
{
    return [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{@"error":errorString}];
}

@end
