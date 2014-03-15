//
//  ViewController.h
//  PostData
//
//  Created by Akshat Singhal on 13/03/14.
//  Copyright (c) 2014 info. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkAdapter.h"
@interface ViewController : UIViewController<UITextViewDelegate,NetworkAdapterDelegate> {
    NetworkAdapter *networkAdapter;
}

@end
