//
//  NTESCSDefine.h
//  NTESToolVerify
//
//  Created by NetEase on 17/4/12.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#ifndef NTESCSDefine_h
#define NTESCSDefine_h


// info.plist
#define NTESCSTOOL_DATA_INFOPLIST_BUILD_KEY             @"CFBundleVersion"
#define NTESCSTOOL_DATA_INFOPLIST_DISPLAYNAME_KEY       @"CFBundleDisplayName"
#define NTESCSTOOL_DATA_INFOPLIST_DISPLAYNAME_VALUE     @"${PRODUCT_NAME}"
#define NTESCSTOOL_DATA_INFOPLIST_DISPLAYNAME_VALUE_    @"$(PRODUCT_NAME)"
#define NTESCSTOOL_DATA_INFOPLIST_BUNDLEID_VALUE        @"$(PRODUCT_BUNDLE_IDENTIFIER)"
#define NTESCSTOOL_DATA_INFOPLIST_FILENAME_KEY          @"Info.plist"

// 特殊文件
#define  NTESCSTOOL_DS_STORE_FILE                       @".DS_Store"
#define  NTESCSTOOL_GIT_FILE                            @".git"
#define  NTESCSTOOL_DOT_PREFIX                          @"."
#define  NTESCSTOOL_BUILD_DIR                           @"Build"
#define  NTESCSTOOL_H_SUFFIX                            @".h"
#define  NTESCSTOOL_M_SUFFIX                            @".m"
#define  NTESCSTOOL_PNG_SUFFIX                          @".png"
#define  NTESCSTOOL_JPG_SUFFIX                          @".jpg"
#define  NTESCSTOOL_TESTS_SUFFIX                        @"Tests"
#define  NTESCSTOOL_FRAMEWORK_SUFFIX                    @".framework"

#endif /* NTESCSDefine_h */
