//
//  NTESPBXArchiveVersion.m
//  pbxprojParser
//
//  Created by NetEase on 17/4/1.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESPBXArchiveVersion.h"
#import "NTESPBXDefine.h"

@implementation NTESPBXArchiveVersion

- (id)init {
    if (self = [super init]) {
        // Initialize self.
        self.key = PBXPRJ_PROJECT_ARCHIVEVER;
    }
    return self;
}

- (BOOL)parseArchiveVersion:(NSString *)object{
    BOOL bResult = YES;
    
    if (object && object.length > 0) {
        self.value = object;
    }
    
    return bResult;
}

@end
