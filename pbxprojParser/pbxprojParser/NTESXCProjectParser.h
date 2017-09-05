//
//  NTESXCProjectParser.h
//  pbxprojParser
//
//  Created by NetEase on 17/3/22.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESPBXObjects.h"
#import "NTESPBXRootObjects.h"
#import "NTESPBXObjectVersion.h"
#import "NTESPBXArchiveVersion.h"
#import "NTESPBXClasses.h"
#import "NTESPBXDefine.h"

#import "NTESPBXObjGroup.h"
#import "NTESPBXObjProject.h"

@interface NTESXCProjectParser : NSObject

@property(nonatomic, strong)NSString *scheme;

/**
 *  单例
 *
 *  @return 返回NTESXCProjectParser对象
 */
+ (NTESXCProjectParser *)sharedInstance;

/**
 *  解析project.pbxproj文件
 *
 *  @param file 项目文件或者工作区文件，比如:.xcodeproj, .xcworkspace文件
 *  @param error 如果解析失败，返回的错误信息
 *
 *  @return BOOL 解析是否成功
 */
- (BOOL)parsePBXProj:(NSString *)file error:(out NSError **)error;

/**
 *  获取项目导出的共有头文件(针对库)
 *
 *  @return NSMutableSet 头文件列表
 */
- (NSMutableSet *)getPublicHeaderFiles;

/**
 *  获取项目的Bundle Identifier
 *
 *  @return NSString bundleid
 */
- (NSString *)getBundleIdentifier;

/**
 *  获取项目的Product Name
 *
 *  @return NSString 显示名从project.pbxproj文件中无法获取，只能获取Product Name
 */
- (NSString *)getProductName;

/**
 *  判断项目的类型
 *
 *  @return BOOL YES:应用 NO:非应用
 */
- (BOOL)isApplication;

/**
 *  获取release下项目使用的三方库
 *
 *  @return NSArray 库列表
 *  @说明     只获取framework和library; release版本
 */
- (NSArray *)getThirdLibraries:(NTESPBXOBJ_CONFIGURATION_TYPE)config;

/**
 *  判断项目适用的平台类型
 *
 *  @return int NTESPBXOBJ_PLATFORM_TYPE_IOS:iPhone应用 NTESPBXOBJ_PLATFORM_TYPE_MACOS:MAC应用
 */
- (NTESPBXOBJ_PLATFORM_TYPE)getPlatformType;

/**
 *  返回InfoPlist文件
 *
 *  @return NSString
 */
- (NSString *)getInfoPlist;

@end
