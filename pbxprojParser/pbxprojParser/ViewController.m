//
//  ViewController.m
//  pbxprojParser
//
//  Created by NetEase on 17/3/21.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "ViewController.h"
#import "NTESCSAppInfo.h"
#import "NTESXCProjectParser.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    
    NSString *projectFile = @"/Users/netease/Desktop/开源项目/AmericanEnglish-master/AmericanEnglish/AmericanEnglish.xcodeproj";
    NSString *infoPlist = @"/Users/netease/Desktop/开源项目/AmericanEnglish-master/AmericanEnglish/AmericanEnglish-Info.plist";
    
    // 通过NTESCSAppInfo类获取
    NSString *appName = [NTESCSAppInfo getAppName:infoPlist project:projectFile];
    NSLog(@"AppName:%@", appName);
    
    NSString *appVer = [NTESCSAppInfo getAppVersion:infoPlist];
    NSLog(@"AppVersion:%@", appVer);
    
    NSString *bundleId = [NTESCSAppInfo getBundleIdentifer:infoPlist project:projectFile];
    NSLog(@"bundle identifier:%@", bundleId);
    
    // 通过NTESXCProjectParser类获取
    NTESXCProjectParser *prj = [NTESXCProjectParser sharedInstance];
    [prj parsePBXProj:projectFile error:nil];
    NSMutableSet *headers = [prj getPublicHeaderFiles];
    NSLog(@"头文件:\n%@", headers);
    
    NSArray *libs = [prj getThirdLibraries:NTESPBXOBJ_CONFIGURATION_TYPE_RELEASE];
    NSLog(@"libraries:%@", libs);
    
    NTESPBXOBJ_PLATFORM_TYPE platform = [prj getPlatformType];
    NSLog(@"platform:%ld", platform);
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.Á
}


@end
