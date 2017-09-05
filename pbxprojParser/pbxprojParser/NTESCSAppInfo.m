//
//  NTESCSAppInfo.m
//  NTESToolVerify
//
//  Created by NetEase on 17/4/13.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESCSAppInfo.h"
#import "NTESCSDefine.h"
#import "NTESXCProjectParser.h"


@implementation NTESCSAppInfo

+ (NSString *)getAppName:(NSString *)plist project:(NSString *)projectFile{
    
    NSString *appName = nil;
    
    if (!projectFile || projectFile.length == 0) {
        return nil;
    }
    
    if(plist && plist.length > 0){
        if([[NSFileManager defaultManager] fileExistsAtPath:plist]) {
            NSMutableDictionary *plistDic =[NSMutableDictionary dictionaryWithContentsOfFile:plist];
            //通过键去取值
            appName = [plistDic objectForKey:NTESCSTOOL_DATA_INFOPLIST_DISPLAYNAME_KEY];
            if (!appName || appName.length == 0) {
                appName = [plistDic objectForKey:(NSString*)kCFBundleNameKey];

            }else{
            }
        }
    }
    
    /* 读取项目配置文件
     * @"$(PRODUCT_NAME)"  @"${PRODUCT_NAME}"
     */
    if (!appName || appName.length == 0 ||
        [appName isEqualToString:NTESCSTOOL_DATA_INFOPLIST_DISPLAYNAME_VALUE] ||
        [appName isEqualToString:NTESCSTOOL_DATA_INFOPLIST_DISPLAYNAME_VALUE_]) {
        
        // 需要读取配置文件
        NSError *error = nil;
        BOOL bRet = [[NTESXCProjectParser sharedInstance] parsePBXProj:projectFile error:&error];
        if (bRet) {
            appName = [[NTESXCProjectParser sharedInstance] getProductName];
        }else{
        }
    }
    
    return  appName;
}

+ (NSString *)getAppVersion:(NSString *)plist{
    NSString *appVer = nil;
    
    if (!plist || plist.length == 0) {
        return nil;
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:plist]) {
        NSMutableDictionary *plistDic =[NSMutableDictionary dictionaryWithContentsOfFile:plist];
        //通过键去取值
        NSString *ver = [plistDic objectForKey:(NSString*)kCFBundleVersionKey];
        NSString *build = [plistDic objectForKey:NTESCSTOOL_DATA_INFOPLIST_BUILD_KEY];
        appVer = [NSString stringWithFormat:@"%@(%@)", ver, build];
    }
    
    return  appVer;
}

+ (NSString *)getBundleIdentifer:(NSString *)plist project:(NSString *)projectFile{
    
    NSString *bundleID = nil;
    
    // plist文件中拿到的是这个宏:$(PRODUCT_BUNDLE_IDENTIFIER)
    if (!projectFile || projectFile.length == 0) {
        return nil;
    }
    
    // 通过plist文件去获取
    if(plist && plist.length > 0){
        if([[NSFileManager defaultManager] fileExistsAtPath:plist]) {
            NSMutableDictionary *plistDic =[NSMutableDictionary dictionaryWithContentsOfFile:plist];
            //通过键去取值
            bundleID = [plistDic objectForKey:(NSString*)kCFBundleIdentifierKey];
        }
    }
    
    /* 需要读取配置文件
     * "$(PRODUCT_BUNDLE_IDENTIFIER)"
     * ch.faludi.${PRODUCT_NAME:rfc1034identifier}
     */
    if (!bundleID || bundleID.length == 0 || [bundleID isEqualToString:NTESCSTOOL_DATA_INFOPLIST_BUNDLEID_VALUE] ||
        [bundleID containsString:PBXOBJ_Target_Native_BUNDLEID_SUB]) {
        
        NSString *bundleIDFromeProj = nil;
        NSError *error = nil;
        BOOL bRet = [[NTESXCProjectParser sharedInstance] parsePBXProj:projectFile error:&error];
        if (bRet) {
            bundleIDFromeProj = [[NTESXCProjectParser sharedInstance] getBundleIdentifier];
        }else{
        }
        
        // 从文件读取的有效值才替换
        if (bundleIDFromeProj && bundleIDFromeProj.length > 0) {
            bundleID = bundleIDFromeProj;
        }
    }
    
    // 如果bundleid含有一些宏定义，则使用PRODUCT_NAME的值替换: ch.faludi.${PRODUCT_NAME:rfc1034identifier}
    if (bundleID) {
        
        NSRange range;
        BOOL bReplase = NO;
        if ( [bundleID containsString:PBXOBJ_Target_Native_BUNDLEID_SUB] ) {
            range = [bundleID rangeOfString:PBXOBJ_Target_Native_BUNDLEID_SUB];
            bReplase = YES;
        }else if([bundleID containsString:PBXOBJ_Target_Native_BUNDLEID_SUB_]){
            range = [bundleID rangeOfString:PBXOBJ_Target_Native_BUNDLEID_SUB_];
            bReplase = YES;
        }
        
        // 需要替换才替换
        if (bReplase) {
            NSString *sub = [bundleID substringToIndex:range.location];
            bundleID = [[NSString alloc] initWithFormat:@"%@%@", sub, [[NTESXCProjectParser sharedInstance] getProductName]];
        }
    }
    
    return  bundleID;
}

@end
