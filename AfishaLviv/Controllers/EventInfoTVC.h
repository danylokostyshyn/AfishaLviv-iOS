//
//  EventInfoTVC.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 27.03.12.

#import <UIKit/UIKit.h>

#import <EventKitUI/EventKitUI.h>

//models
#import "Event.h"

@interface EventInfoTVC : UIViewController <UITableViewDelegate, UITableViewDataSource,
    UIWebViewDelegate, UIActionSheetDelegate, EKEventEditViewDelegate>

- (id)initWithEvent:(Event *)event;

@end
