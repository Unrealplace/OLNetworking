//
//  NSError+Error.h
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (Error)

- (NSString *)errorString;

+ (NSError *)errorWithString:(NSString *)errorString;

@end

NS_ASSUME_NONNULL_END
