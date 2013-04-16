//
//  EventInfoTVC.h
//  AfishaLviv
//
//  Created by Mac on 27.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <EventKitUI/EventKitUI.h>

#import "Event+AfishaLviv.h"

@interface EventInfoTVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UIActionSheetDelegate, EKEventEditViewDelegate>

- (id)initWithEvent:(Event *)event;

@end
