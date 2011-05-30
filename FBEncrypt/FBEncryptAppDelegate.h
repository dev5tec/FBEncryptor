//
//  FBEncryptAppDelegate.h
//  FBEncrypt
//
//  Created by Hiroshi Hashiguchi on 11/05/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBEncryptViewController;

@interface FBEncryptAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet FBEncryptViewController *viewController;

@end
