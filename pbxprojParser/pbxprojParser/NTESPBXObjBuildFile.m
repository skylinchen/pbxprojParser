//
//  NTESPBXObjBuildFile.m
//  pbxprojParser
//
//  Created by NetEase on 17/3/22.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESPBXObjBuildFile.h"
#import "NTESPBXDefine.h"

@implementation NTESPBXObjBuildFile

- (id)init {
    if (self = [super init]) {
        // Initialize self.
        self.isaValue = PBXOBJ_BuildFile;
    }
    return self;
}

- (BOOL)parseValue:(NSDictionary *)value forkey:(NSString *)key{
    BOOL bResult = YES;
    
    if (!value || value.count == 0 || !key) {
        return bResult;
    }
    
    self.guid = key;
    self.fileRef = value[PBXOBJ_BuildFile_FILEREF];
    self.settings = value[PBXOBJ_BuildFile_SETTINGS];
    if (self.settings && [self.settings.allKeys containsObject:PBXOBJ_BuildFile_SETTINGS_ATTR]) {
        self.settings_attr = self.settings[PBXOBJ_BuildFile_SETTINGS_ATTR];
    }
    
    return bResult;
}

@end
