//
//  NTESPBXObjFileElement.m
//  pbxprojParser
//
//  Created by NetEase on 17/4/5.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESPBXObjFileElement.h"
#import "NTESPBXDefine.h"

@implementation NTESPBXObjFileElement

- (BOOL)parseValue:(NSDictionary *)value forkey:(NSString *)key{
    BOOL bResult = YES;
    
    if (!value || value.count == 0 || !key) {
        return bResult;
    }
    
    self.guid = key;
    self.isaValue = value[PBXOBJ_ISA_KEY];
    self.fileEncoding = (NSInteger)value[PBXOBJ_FileElement_FR_fileEncoding];
    self.explicitFileType = value[PBXOBJ_FileElement_FR_explicitFileType];
    self.lastKnownFileType = value[PBXOBJ_FileElement_FR_lastKnownFileType];
    self.name = value[PBXOBJ_FileElement_FR_name];
    self.path = value[PBXOBJ_FileElement_FR_path];
    self.sourceTree = value[PBXOBJ_FileElement_FR_sourceTree];
    
    return bResult;
}

@end
