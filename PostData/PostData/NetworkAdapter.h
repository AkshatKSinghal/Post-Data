//
//  NetworkAdapter.h
//  PostData
//
//  Created by Akshat Singhal on 15/03/14.
//  Copyright (c) 2014 info. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkAdapterDelegate
- (void)networkAdapterDelegateDidFinish:(NSDictionary *)response;
@end

@interface NetworkAdapter : NSObject{
    NSMutableData *appData;
    id<NetworkAdapterDelegate> delegate;
}
@property (nonatomic, strong) id delegate;
- (void)postData:(NSDictionary *)data;
@end
