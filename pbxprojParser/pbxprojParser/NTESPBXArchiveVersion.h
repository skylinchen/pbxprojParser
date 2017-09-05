//
//  NTESPBXArchiveVersion.h
//  pbxprojParser
//
//  Created by NetEase on 17/4/1.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESPBXArchiveVersion : NSObject

@property(nonatomic, strong)NSString *key;
@property(nonatomic, strong)NSString *value;

- (BOOL)parseArchiveVersion:(NSString *)object;

@end
