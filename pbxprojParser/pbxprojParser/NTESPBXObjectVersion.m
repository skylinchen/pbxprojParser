//
//  NTESPBXObjectVersion.m
//  pbxprojParser
//
//  Created by NetEase on 17/4/1.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESPBXObjectVersion.h"
#import "NTESPBXDefine.h"

@implementation NTESPBXObjectVersion

- (id)init {
    if (self = [super init]) {
        // Initialize self.
        self.key = PBXPRJ_PROJECT_OBJVERSION;
    }
    return self;
}

- (BOOL)parseObjVersion:(NSString *)object{
    BOOL bResult = YES;
    
    if (object && object.length > 0) {
        self.value = object;
    }
    
    return bResult;
}

@end
