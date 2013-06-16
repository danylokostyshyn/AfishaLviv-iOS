//
//  EventInfoTVC.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 27.03.12.

#import "ALViewController.h"

#import <EventKitUI/EventKitUI.h>

@class ALEvent;
@interface ALEventInfoViewController : ALViewController <UITableViewDelegate, UITableViewDataSource,
    UIWebViewDelegate, UIActionSheetDelegate, EKEventEditViewDelegate>
@property (strong, nonatomic) ALEvent *event;
@end
