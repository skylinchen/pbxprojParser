//
//  NTESPBXObjectVersion.h
//  pbxprojParser
//
//  Created by NetEase on 17/4/1.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESPBXObjectVersion : NSObject

@property(nonatomic, strong)NSString *key;
@property(nonatomic, strong)NSString *value;

- (BOOL)parseObjVersion:(NSString *)object;

@end
