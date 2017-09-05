//
//  NTESPBXObjects.h
//  pbxprojParser
//
//  Created by NetEase on 17/3/22.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESPBXDefine.h"
#import "NTESPBXObjProject.h"
#import "NTESPBXObjGroup.h"
#import "NTESPBXObjBuildFile.h"
#import "NTESPBXObjBuildPhase.h"
#import "NTESPBXObjFileElement.h"
#import "NTESPBXObjBuildConfiguration.h"
#import "NTESPBXObjNativeTarget.h"

typedef NS_ENUM(NSInteger, NTESPBXOBJ_SEARCHPATH_TYPE){
    NTESPBXOBJ_SEARCHPATH_TYPE_FRAMEWORK = 0,
    NTESPBXOBJ_SEARCHPATH_TYPE_LIBRARY,
    NTESPBXOBJ_SEARCHPATH_TYPE_LD_RUNPATH,
};

typedef NS_ENUM(NSInteger, NTESPBXOBJ_CONFIGURATION_TYPE){
    NTESPBXOBJ_CONFIGURATION_TYPE_DEBUG = 0,
    NTESPBXOBJ_CONFIGURATION_TYPE_RELEASE,
};

@interface NTESPBXObjects : NSObject

@property(nonatomic, strong)NSString *key;

@property(nonatomic, strong)NSDictionary *pbxObjGroups;
@property(nonatomic, strong)NSDictionary *pbxObjProjects;
@property(nonatomic, strong)NSDictionary *pbxObjBuildFiles;
@property(nonatomic, strong)NSDictionary *pbxObjBuildPhases;
@property(nonatomic, strong)NSDictionary *pbxObjFileElements;
@property(nonatomic, strong)NSDictionary *pbxObjBuildConfigurations;
@property(nonatomic, strong)NSDictionary *pbxObjTargets;

- (BOOL)parserObjects:(NSDictionary *)objects;
- (NSMutableSet *)getPublicHeaderFiles;
- (NSString *)getBundleIdentifier:(NSString *)scheme;

// 获取除了test工程的其他所有工程的product name，多个以分号隔开
- (NSString *)getProductName:(NSString *)scheme;
- (BOOL)isApplication;

// 获取第三方库
- (NSArray *)getThirdLibraries:(NSString *)projectDir configuration:(NTESPBXOBJ_CONFIGURATION_TYPE)config;

- (NTESPBXOBJ_PLATFORM_TYPE)getPlatformType;

- (NSString *)getInfoPlist:(NSString *)scheme;

@end
