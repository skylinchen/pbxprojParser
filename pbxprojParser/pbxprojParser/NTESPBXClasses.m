//
//  NTESPBXClasses.m
//  pbxprojParser
//
//  Created by NetEase on 17/4/1.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESPBXClasses.h"
#import "NTESPBXDefine.h"

@implementation NTESPBXClasses

- (id)init {
    if (self = [super init]) {
        // Initialize self.
        self.key = PBXPRJ_PROJECT_CLASSES;
    }
    return self;
}

- (BOOL)parseClasses:(NSDictionary *)objects{
    BOOL bResult = YES;
    
    if (objects && [objects isKindOfClass:[NSDictionary class]] && objects.count > 0) {
        self.value = objects;
    }
    
    return bResult;
}

@end
