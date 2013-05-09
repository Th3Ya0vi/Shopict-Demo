//
//  SBEnum.h
//  ShopbookAPI
//
//  Created by BCKK on 12年11月10日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

typedef enum {
    FACEBOOK,
    TWITTER,
    WEIBO
}ThirdPartyPath;

typedef enum {
    SHARE,
    SELL,
    WANT
}PostType;

typedef enum {
    IPHONE,
    IPAD,
}DeviceType;

typedef enum {
    FOLLOWING,
    FOLLOWED,
}FollowType;

typedef enum {
    PEOPLE,
    PRODUCT,
    TAG,
}SearchType;

typedef enum {
    FOLLOW,
}NewsType;

//Notification Handling

typedef enum {
    POSTDIDADD,
    POSTDIDDELETE,
    POSTDIDWANT,
    POSTDIDUNWANT,
    POSTDIDCOMMENT,
    ACCOUNTDIDFOLLOW,
    ACCOUNTDIDUNFOLLOW,
    ACCOUNTDIDUPDATE,
    ACCOUNTDIDUPDATEFORPOST,
    POSTDIDREPOST,
    POSTDIDUNREPOST,
}NotificationType;

typedef enum {
    INAPPROPRIATECONTENT,
    NOTAVAILABLE,
    INCORRECTPRICE,
    BADIMAGE,
}ReportPostWithURLType;

