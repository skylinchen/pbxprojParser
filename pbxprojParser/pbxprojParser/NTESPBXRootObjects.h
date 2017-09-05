//
//  NTESPBXRootObjects.h
//  pbxprojParser
//
//  Created by NetEase on 17/3/22.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESPBXRootObjects : NSObject

@property(nonatomic, strong)NSString *key;
@property(nonatomic, strong)NSString *value;

- (BOOL)parseRootObject:(NSString *)object;

@end
