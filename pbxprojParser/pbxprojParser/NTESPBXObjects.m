//
//  NTESPBXObjects.m
//  pbxprojParser
//
//  Created by NetEase on 17/3/22.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESPBXObjects.h"
#import "NTESPBXDefine.h"

@implementation NTESPBXObjects

- (id)init {
    if (self = [super init]) {
        // Initialize self.
        self.key = PBXPRJ_PROJECT_OBJECTS;
        self.pbxObjGroups = [[NSMutableDictionary alloc] init];
        self.pbxObjProjects = [[NSMutableDictionary alloc] init];
        self.pbxObjBuildFiles = [[NSMutableDictionary alloc] init];
        self.pbxObjBuildPhases = [[NSMutableDictionary alloc] init];
        self.pbxObjFileElements = [[NSMutableDictionary alloc] init];
        self.pbxObjBuildConfigurations = [[NSMutableDictionary alloc] init];
        self.pbxObjTargets = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BOOL)parserObjects:(NSDictionary *)objects{
    BOOL bResult = YES;
    
    if (!objects || objects.count == 0) {
        return NO;
    }
    
    for (NSString *key in objects) {
        NSDictionary *value = objects[key];
        if (value && value.count > 0) {
            NSString *isaValue = value[PBXOBJ_ISA_KEY];
            if ([isaValue isEqualToString:PBXOBJ_BuildFile]) {
                NTESPBXObjBuildFile *obj = [[NTESPBXObjBuildFile alloc] init];
                obj.guid = key;
                obj.isaValue = isaValue;
                [obj parseValue:value forkey:key];
                
                [self.pbxObjBuildFiles setValue:obj forKey:obj.guid];
            }else if([isaValue isEqualToString:PBXOBJ_FileElement_FileReference] ||
                     [isaValue isEqualToString:PBXOBJ_FileElement_Group] ||
                     [isaValue isEqualToString:PBXOBJ_FileElement_VariantGroup]){
                NTESPBXObjFileElement *obj = [[NTESPBXObjFileElement alloc] init];
                [obj parseValue:value forkey:key];
                
                [self.pbxObjFileElements setValue:obj forKey:key];
            }else if([isaValue isEqualToString:PBXOBJ_BuildConfiguration]){
                NTESPBXObjBuildConfiguration *obj = [[NTESPBXObjBuildConfiguration alloc] init];
                obj.guid = key;
                obj.isaValue = isaValue;
                [obj parseValue:value forkey:key];
                
                [self.pbxObjBuildConfigurations setValue:obj forKey:obj.guid];
            }else if([isaValue isEqualToString:PBXOBJ_Target_Native]){
                NTESPBXObjNativeTarget *obj = [[NTESPBXObjNativeTarget alloc] init];
                obj.guid = key;
                obj.isaValue = isaValue;
                [obj parseValue:value forkey:key];
                
                [self.pbxObjTargets setValue:obj forKey:obj.guid];
            }else if([isaValue isEqualToString:PBXOBJ_BuildPhase_Frameworks]) {
                
            }
        }
    }
    
    return bResult;
}

- (NSMutableSet *)getPublicHeaderFiles{
    
    // NSMutableSet能自动对数据去重
    NSMutableSet *result = nil;
    if (!self.pbxObjFileElements || !self.pbxObjBuildFiles) {
        return result;
    }
    
    result = [[NSMutableSet alloc] init];
    for (NSString *key in self.pbxObjBuildFiles) {
        NTESPBXObjBuildFile *buildFile = self.pbxObjBuildFiles[key];
        if (buildFile.settings && buildFile.settings.allKeys.count > 0) {
            NSArray *attrs = buildFile.settings[PBXOBJ_BuildFile_SETTINGS_ATTR];
            if (!attrs && attrs.count == 0) {
                break;
            }
            
            // 匹配"Public"属性
            if ([attrs containsObject:PBXOBJ_BuildFile_SETTINGS_ATTR_1]) {
                NSString *fileRef = buildFile.fileRef;
                
                // 到PBXFileReference里去查找name或者path
                if ([self.pbxObjFileElements objectForKey:fileRef]) {
                    NTESPBXObjFileElement *fileElement = self.pbxObjFileElements[fileRef];
                    if (fileElement.name || fileElement.name.length > 0) {
                        [result addObject:fileElement.name];
                    }else if(fileElement.path || fileElement.path.length > 0){
                        [result addObject:fileElement.path];
                    }
                }
            }
        }
    }
    
    return result;
}

- (NSString *)getBundleIdentifier:(NSString *)scheme{
    
    NSString *result = nil;
    
    if (!self.pbxObjBuildConfigurations) {
        return nil;
    }
    
    NSString *productName = [self getProductName:scheme];
    NSArray *names = [productName componentsSeparatedByString:@";"];
    if (!names || names.count == 0) {
        return nil;
    }
    
    NSMutableSet *bundleIdSet_valid = [[NSMutableSet alloc] init];
    NSMutableSet *bundleIdSet_invalid = [[NSMutableSet alloc] init];
    for (NSString *key in self.pbxObjBuildConfigurations) {
        NTESPBXObjBuildConfiguration *buildConfiguration = self.pbxObjBuildConfigurations[key];
        
        if (!buildConfiguration.settings_product_name || buildConfiguration.settings_product_name.length == 0) {
            continue;
        }
        
        NSString *bundleId = nil;
        // 读取productName的值跟NativeTarget里获取的productName值一样的bundleid
        if ([names containsObject:buildConfiguration.settings_product_name]) {
            /*NativeTarget中的productName是有效的，XCBuildConfiguration中的productName也是有效的
             NativeTarget:
                "productName" : "StoreFinder",
                "isa" : "PBXNativeTarget",
             XCBuildConfiguration:
                "buildSettings" : {
                    "PRODUCT_BUNDLE_IDENTIFIER" : "com.merkabahnk.2City",
                    "PRODUCT_NAME" : "StoreFinder",
                },
             */
            bundleId = buildConfiguration.settings_bundle_id;
            if (!bundleId) {
                continue;
            }
        }else{
            /* NativeTarget中的productName是有效的，但是XCBuildConfiguration中的productName却是无效的
             NativeTarget:
                "productName" : "AGEmojiKeyboardSample",
                "isa" : "PBXNativeTarget",
             
             XCBuildConfiguration:
                "buildSettings" : {
                "PRODUCT_NAME" : "$(TARGET_NAME)",
                "PRODUCT_BUNDLE_IDENTIFIER" : "to.emojiKeyBoard.${PRODUCT_NAME:rfc1034identifier}",
                }
             */
            bundleId = buildConfiguration.settings_bundle_id;
            if(!bundleId){
                continue;
            }
        }
        
        // 如果bundleid含有一些宏定义，则使用PRODUCT_NAME的值替换: to.emojiKeyBoard.${PRODUCT_NAME:rfc1034identifier
        if (bundleId && ([bundleId containsString:PBXOBJ_Target_Native_BUNDLEID_SUB] ||
                         [bundleId containsString:PBXOBJ_Target_Native_BUNDLEID_SUB_])) {
            
            NSRange range = [bundleId rangeOfString:PBXOBJ_Target_Native_BUNDLEID_SUB];
            if (range.location == NSNotFound) {
                range = [bundleId rangeOfString:PBXOBJ_Target_Native_BUNDLEID_SUB_];
            }
            
            if (range.location != NSNotFound) {
                NSString *sub = [bundleId substringToIndex:range.location];
                
                for (NSString *name in names) {
                    NSString *bundleId_replace = [[NSString alloc] initWithFormat:@"%@%@", sub, name];
                    [bundleIdSet_invalid addObject:bundleId_replace];
                }
            }
            
        }else{
            // 不含有宏定义，排除Tests工程
            if([bundleId hasSuffix:NTESCSTOOL_TESTS_SUFFIX]){
                [bundleIdSet_invalid addObject:bundleId];
            }else{
                [bundleIdSet_valid addObject:bundleId];
            }
        }
    }
    
    NSMutableString *ids = [[NSMutableString alloc] init];
    if (bundleIdSet_valid && bundleIdSet_valid.count > 0) {
        for (NSString *bundleid in bundleIdSet_valid) {
            [ids appendFormat:@"%@;", bundleid];
        }
    }else if (bundleIdSet_invalid && bundleIdSet_invalid.count > 0){
        for (NSString *bundleid in bundleIdSet_invalid) {
            [ids appendFormat:@"%@;", bundleid];
        }
    }
    
    NSInteger len = ids.length;
    if(len > 2){
        // 去掉最后的分号
        NSString *substr = [ids substringToIndex:len - 1];
        result = substr;
    }
    
    return result;
}

- (NSString *)getProductName:(NSString *)scheme{
    
    NSMutableString *result = nil;
    
    /*if (!scheme || scheme.length == 0) {
        return result;
    }*/
    
    if (!self.pbxObjTargets) {
        return result;
    }
   
    NSMutableDictionary *productNames = [[NSMutableDictionary alloc] init];
    for (NSString *key in self.pbxObjTargets) {
        NTESPBXObjNativeTarget *nativeTarget = self.pbxObjTargets[key];
        NSString *name = nativeTarget.productName;
        
        // 排除Tests工程 和 UITests工程 的数据
        if (name && name.length > 0 && ![name hasSuffix:NTESCSTOOL_TESTS_SUFFIX]) {
            [productNames setObject:nativeTarget.productType forKey:name];
        }
    }
    
    /* 有多个的话，根据productType区分下。app的类型是"com.apple.product-type.application"
     *  (1) "productType" : "com.apple.product-type.application",
     "productName" : "Demo",
     "isa" : "PBXNativeTarget",
     *
     *  (2) "productType" : "com.apple.product-type.library.static",
     "productName" : "BFNavigationBarDrawer",
     "isa" : "PBXNativeTarget",
     *  (3) "productType" : "com.apple.product-type.framework",
     *  (4) "productType" : "com.apple.product-type.bundle.unit-test",
     *  (5) "productType" : "com.apple.product-type.application.messages",
     "productType" : "com.apple.product-type.app-extension.messages-sticker-pack",
     "productName" : "StickerPackExtension",
     *  (6)
     cocoa
     *  (7) "productType" : "com.apple.product-type.application",
     "productName" : "cocoaApp",
     "isa" : "PBXNativeTarget",
        (8) "productType" : "com.apple.product-type.tool",
     */
    NSMutableString *productName = [[NSMutableString alloc] init];
    if (productNames.count > 0) {
        for (NSString *key in productNames) {
            NSString *type = [productNames objectForKey:key];
            if([type isEqualToString:PBXOBJ_Target_Native_PT_APPVALUE] ||
               [type isEqualToString:PBXOBJ_Target_Native_PT_DYMLIBVALUE] ||
               [type isEqualToString:PBXOBJ_Target_Native_PT_STATICLIBVALUE] ||
               [type isEqualToString:PBXOBJ_Target_Native_PT_ToolVALUE]){
                
                [productName appendFormat:@"%@;", key];
            }
        }
        
        // 没有符合我们上面的类型，则添加全部的
        if (productName.length == 0) {
            for (NSString *key in productNames) {
                [productName appendFormat:@"%@;", key];
            }
        }
        
        NSInteger len = productName.length;
        if(len > 2){
            // 去掉最后的分号
            NSString *substr = [productName substringToIndex:len - 1];
            productName = [[NSMutableString alloc] initWithString:substr];
        }
    }
    
    // 判断是否有和schme匹配的product name
    if (productName && productName.length > 0) {
        NSArray *names = [productName componentsSeparatedByString:@";"];
        if (names && names.count > 0) {
            for (NSString *name in names) {
                if ([name isEqualToString:scheme]) {
                    result = [[NSMutableString alloc] initWithString:name];
                    break;
                }
            }
        }
    }
    
    if (!result || result.length == 0) {
        result = productName;
    }
    
    return result;
}

- (BOOL)isApplication{
    BOOL result = NO;
    
    if (!self.pbxObjTargets) {
        return result;
    }
    
    /* 有多个的话，根据productType来查找是否有app的类型。app的类型是(1)(5)(8)
     iOS
     *  (1) "productType" : "com.apple.product-type.application",
            "productName" : "Demo",
            "isa" : "PBXNativeTarget",
     *
     *  (2) "productType" : "com.apple.product-type.library.static",
            "productName" : "BFNavigationBarDrawer",
            "isa" : "PBXNativeTarget",
     *  (3) "productType" : "com.apple.product-type.framework",
     *  (4) "productType" : "com.apple.product-type.bundle.unit-test",
     *  (5) "productType" : "com.apple.product-type.application.messages",
            "productType" : "com.apple.product-type.app-extension.messages-sticker-pack",
            "productName" : "StickerPackExtension",
     *  (6)
     cocoa
     *  (7) "productType" : "com.apple.product-type.application",
            "productName" : "cocoaApp",
            "isa" : "PBXNativeTarget",
        (8) "productType" : "com.apple.product-type.tool",
     */
    for (NSString *key in self.pbxObjTargets) {
        NTESPBXObjNativeTarget *nativeTarget = self.pbxObjTargets[key];
        NSString *name = nativeTarget.productName;
        
        // 排除Tests工程的数据
        if (name && name.length > 0 && [name hasSuffix:NTESCSTOOL_TESTS_SUFFIX]) {
            continue;
        }
        
        // 含有"com.apple.product-type.application"类型，就表示是App
        if([nativeTarget.productType isEqualToString:PBXOBJ_Target_Native_PT_APPVALUE] ||
           [nativeTarget.productType isEqualToString:PBXOBJ_Target_Native_PT_ToolVALUE] ||
           [nativeTarget.productType hasPrefix:PBXOBJ_Target_Native_PT_PreffixVALUE]){
            result = YES;
            break;
        }
    }
    
    return result;
}

- (NSArray *)getAllLibraries{
    
    NSMutableArray *result = nil;
    if (!self.pbxObjFileElements) {
        return result;
    }
    
    result = [[NSMutableArray alloc] init];
    for (NSString *key in self.pbxObjFileElements) {
        NTESPBXObjFileElement *fileElement = self.pbxObjFileElements[key];
        if (!fileElement.lastKnownFileType || fileElement.lastKnownFileType.length == 0) {
            continue;
        }
        
        /*wrapper.framework的"lastKnownFileType" = "wrapper.framework"
         "E68F92491D1140F7007AB91D" : {
            "path" : "BugrptSDKDemo\/Bugrpt.framework",
            "isa" : "PBXFileReference",
            "name" : "Bugrpt.framework",
            "lastKnownFileType" : "wrapper.framework",
            "sourceTree" : "<group>"
         }
         
         .a 的"lastKnownFileType" = "archive.ar"
         "E3D72A831B69F720007AE405" : {
            "path" : "libWeChatSDK.a",
            "isa" : "PBXFileReference",
            "lastKnownFileType" : "archive.ar",
            "sourceTree" : "<group>"
         },
         
         libPods-xxx.a 的"explicitFileType" = "archive.ar"
         "269B15C57598DB6989F26C89" : {
            "path" : "libPods-chuanke.a",
            "isa" : "PBXFileReference",
            "includeInIndex" : "0",
            "explicitFileType" : "archive.ar",
            "sourceTree" : "BUILT_PRODUCTS_DIR"
         },
         */
        if ([fileElement.lastKnownFileType isEqualToString:PBXOBJ_FileElement_FR_lastKnownFileType_FRAMEWORK] ||
            [fileElement.lastKnownFileType isEqualToString:PBXOBJ_FileElement_FR_lastKnownFileType_Library]) {
            [result addObject:fileElement.path];
        }
    }
    
    return result;
}

- (NSMutableSet *)getAllSearchPath:(NSString *)projectDir configuration:(NTESPBXOBJ_CONFIGURATION_TYPE)config{
    
    NSMutableSet *setFramwork = [self getSearchPath:NTESPBXOBJ_SEARCHPATH_TYPE_FRAMEWORK forConfiguration:config];
    NSMutableSet *setLibrary = [self getSearchPath:NTESPBXOBJ_SEARCHPATH_TYPE_LIBRARY forConfiguration:config];
    //NSMutableSet *setLd = [self getSearchPath:NTESPBXOBJ_SEARCHPATH_TYPE_LD_RUNPATH config];
    
    NSSet *all = [setFramwork setByAddingObjectsFromSet:setLibrary];
    
    NSMutableSet *result = [[NSMutableSet alloc] init];
    for (NSString *lib  in all){
        
        /* 排除 $(inherited) 和 $(SDKROOT)开头的
         $(inherited)指pod路径
         "$(SDKROOT)/Developer/Library/Frameworks"
        */
        if ( [lib isEqualToString:PBXOBJ_FileElement_FR_PATH_INHERITED] ||
            [lib hasPrefix:PBXOBJ_FileElement_FR_PATH_SDKROOT]) {
            continue;
        }
        
        /* 替换 $(PROJECT_DIR)开头的路径
        "$(PROJECT_DIR)/BugrptSDKDemo/UdeskSDK/SDK",
        */
        if ([lib hasPrefix:PBXOBJ_FileElement_FR_PATH_PROJECT_DIR]) {
            NSRange range = [lib rangeOfString:PBXOBJ_FileElement_FR_PATH_PROJECT_DIR];
            if(range.location != NSNotFound){
                NSString *newLib = [lib stringByReplacingCharactersInRange:range withString:projectDir];
                [result addObject:newLib];
            }
        }else{
            [result addObject:lib];
        }
    }
    
    /*for (NSString *ld  in setLd){
        [result addObject:ld];
    }*/
    
    return result;
}

- (NSMutableSet *)getSearchPath:(NTESPBXOBJ_SEARCHPATH_TYPE)type forConfiguration:(NTESPBXOBJ_CONFIGURATION_TYPE)config{
    
    NSString *configuration = nil;
    // NSMutableSet能自动对数据去重
    NSMutableSet *result = nil;
    
    if (config == NTESPBXOBJ_CONFIGURATION_TYPE_DEBUG) {
        configuration = PBXOBJ_BC_NAME_DEBUG;
    }else if(config == NTESPBXOBJ_CONFIGURATION_TYPE_RELEASE){
        configuration = PBXOBJ_BC_NAME_RELEASE;
    }
    
    result = [[NSMutableSet alloc] init];
    for (NSString *key in self.pbxObjBuildConfigurations) {
        NTESPBXObjBuildConfiguration *buildConfiguration = self.pbxObjBuildConfigurations[key];
        
        // 匹配项目配置
        if ([buildConfiguration.name isEqualToString:configuration]) {
            
            id searchPath = nil;
            if (type == NTESPBXOBJ_SEARCHPATH_TYPE_LIBRARY) {
                searchPath = buildConfiguration.settings_search_path_library;
            }else if(type == NTESPBXOBJ_SEARCHPATH_TYPE_FRAMEWORK){
                searchPath = buildConfiguration.settings_search_path_framework;
            }else if(type == NTESPBXOBJ_SEARCHPATH_TYPE_LD_RUNPATH){
                searchPath = buildConfiguration.settings_search_path_ld_runpath;
            }
            
            if (searchPath) {
                if ([searchPath isKindOfClass:[NSSet class]] ||
                    [searchPath isKindOfClass:[NSArray class]]) {
                    for (NSString *library in searchPath) {
                        [result addObject:library];
                    }
                }else if ([searchPath isKindOfClass:[NSString class]]){
                    NSString *value = searchPath;
                    if (value && value.length > 0) {
                        [result addObject:value];
                    }
                }
            }
        }
    }
    
    return result;
    
}

- (NSArray *)getThirdLibraries:(NSString *)projectDir configuration:(NTESPBXOBJ_CONFIGURATION_TYPE)config{
    
    if (!projectDir || projectDir.length == 0) {
        return nil;
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSArray *allLibraries = [self getAllLibraries];
    NSMutableSet *paths = [self getAllSearchPath:projectDir configuration:NTESPBXOBJ_CONFIGURATION_TYPE_RELEASE];
    if (!allLibraries || allLibraries.count == 0) {
        return result;
    }
    
    for (NSString *lib in allLibraries) {
        if (!lib || lib.length == 0) {
            continue;
        }
        
        // 排除系统库
        if ([lib hasPrefix:PBXOBJ_FileElement_FR_PATH_SYSTEM] ||
            [lib hasPrefix:PBXOBJ_FileElement_FR_PATH_SYSTEM_lib]) {
            continue;
        }
        
        // 判断库文件是否存在，不存在的话加上搜索路径
        if([[NSFileManager defaultManager] fileExistsAtPath:lib]){
            [result addObject:lib];
        }else{
            // 和搜索路径组合，判断库的有效性
            for (NSString *path in paths) {
                NSString *libPath = [NSString stringWithFormat:@"%@/%@", path, [lib lastPathComponent]];
                if([[NSFileManager defaultManager] fileExistsAtPath:libPath]){
                    [result addObject:libPath];
                }
            }
        }
        
    }
    
    return result;
}

/* 根据 SDKROOT 来判断平台
 "E67548621ADE4A520091CAD8" : {
    "isa" : "XCBuildConfiguration",
    "buildSettings" : {
    "CLANG_WARN_ENUM_CONVERSION" : "YES",
    "GCC_WARN_UNUSED_VARIABLE" : "YES",
    "VALIDATE_PRODUCT" : "YES",
    "GCC_WARN_ABOUT_RETURN_TYPE" : "YES_ERROR",
    "CLANG_ENABLE_MODULES" : "YES",
    "CLANG_CXX_LANGUAGE_STANDARD" : "gnu++0x",
    "GCC_WARN_UNINITIALIZED_AUTOS" : "YES_AGGRESSIVE",
    "CLANG_WARN_INT_CONVERSION" : "YES",
    "MTL_ENABLE_DEBUG_INFO" : "NO",
    "CLANG_WARN_CONSTANT_CONVERSION" : "YES",
    "GCC_C_LANGUAGE_STANDARD" : "gnu99",
    "TARGETED_DEVICE_FAMILY" : "1,2",
    "CLANG_WARN__DUPLICATE_METHOD_MATCH" : "YES",
    "CLANG_WARN_EMPTY_BODY" : "YES",
    "GCC_WARN_64_TO_32_BIT_CONVERSION" : "YES",
    "ALWAYS_SEARCH_USER_PATHS" : "NO",
    "COPY_PHASE_STRIP" : "NO",
    "CLANG_ENABLE_OBJC_ARC" : "YES",
    "CLANG_WARN_BOOL_CONVERSION" : "YES",
    "CLANG_WARN_DIRECT_OBJC_ISA_USAGE" : "YES_ERROR",
    "GCC_WARN_UNUSED_FUNCTION" : "YES",
    "CLANG_WARN_OBJC_ROOT_CLASS" : "YES_ERROR",
    "CODE_SIGN_IDENTITY[sdk=iphoneos*]" : "iPhone Developer",
    "ENABLE_NS_ASSERTIONS" : "NO",
    "IPHONEOS_DEPLOYMENT_TARGET" : "6.0",
    "SDKROOT" : "iphoneos",
    "CLANG_CXX_LIBRARY" : "libc++",
    "ENABLE_STRICT_OBJC_MSGSEND" : "YES",
    "CLANG_WARN_UNREACHABLE_CODE" : "YES",
    "GCC_WARN_UNDECLARED_SELECTOR" : "YES"
    },
    "name" : "Release"
 },
 */
- (NTESPBXOBJ_PLATFORM_TYPE)getPlatformType{
    
    NTESPBXOBJ_PLATFORM_TYPE platform = NTESPBXOBJ_PLATFORM_TYPE_DEFAULT;
    
    if (!self.pbxObjBuildConfigurations) {
        return platform;
    }
    
    for (NSString *key in self.pbxObjBuildConfigurations) {
        NTESPBXObjBuildConfiguration *buildConfiguration = self.pbxObjBuildConfigurations[key];
        
        NSString *sdkroot = buildConfiguration.settings_sdkroot;
        if (sdkroot && [sdkroot isEqualToString:PBXOBJ_BC_BS_SDKROOT_VALUE_IOS]) {
            platform = NTESPBXOBJ_PLATFORM_TYPE_IOS;
            break;
        }else if(sdkroot && [sdkroot isEqualToString:PBXOBJ_BC_BS_SDKROOT_VALUE_MAC]){
            platform = NTESPBXOBJ_PLATFORM_TYPE_MACOS;
            break;
        }
    }
    
    return platform;
}

- (NSString *)getInfoPlist:(NSString *)scheme{
    
    if (!self.pbxObjBuildConfigurations) {
        return nil;
    }
    
    NSString *infoPlistFile = nil;
    
    NSMutableArray *files = [[NSMutableArray alloc] init];
    for (NSString *key in self.pbxObjBuildConfigurations) {
        NTESPBXObjBuildConfiguration *buildConfiguration = self.pbxObjBuildConfigurations[key];
        
        NSString *file = buildConfiguration.settings_infoplist_file;
        if (file && file.length > 0) {
            [files addObject:file];
        }
    }
    
    if (files.count == 1) {
        infoPlistFile = files[0];
    }else if(files.count > 1){
        
        NSMutableSet *valid_files_set = [[NSMutableSet alloc] init];
        // 去除多余的InfoPlist文件，先排除Tests
        for (NSString *plist in files) {
            if ([plist containsString:NTESCSTOOL_TESTS_CONTAIN]) {
                continue;
            }
            
            [valid_files_set addObject:plist];
        }
        
        NSArray *valid_files_arr = [valid_files_set allObjects];
        if (valid_files_arr.count == 1) {
            infoPlistFile = valid_files_arr[0];
        }else if(valid_files_arr.count > 1){
            for (NSString *valid_plist in valid_files_arr) {
                NSString *suffix1 = [NSString stringWithFormat:@"%@/%@", scheme, NTESCSTOOL_INFOPLIST_FILENAME];
                NSString *suffix2 = [NSString stringWithFormat:@"%@_%@", scheme, NTESCSTOOL_INFOPLIST_FILENAME];
                NSString *suffix3 = [NSString stringWithFormat:@"%@/%@_%@", scheme, scheme, NTESCSTOOL_INFOPLIST_FILENAME];
                if ([valid_plist hasSuffix:suffix1] ||
                    [valid_plist hasSuffix:suffix2] ||
                    [valid_plist hasSuffix:suffix3]) {
                    infoPlistFile = valid_plist;
                }
            }
        }        
    }
    
    return infoPlistFile;
}

@end
