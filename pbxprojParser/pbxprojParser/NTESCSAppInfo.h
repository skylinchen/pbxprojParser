//
//  NTESCSAppInfo.h
//  NTESToolVerify
//
//  Created by NetEase on 17/4/13.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESCSAppInfo : NSObject

+ (NSString *)getAppName:(NSString *)plist project:(NSString *)projectFile;
+ (NSString *)getAppVersion:(NSString *)plist;
+ (NSString *)getBundleIdentifer:(NSString *)plist project:(NSString *)projectFile;

@end
