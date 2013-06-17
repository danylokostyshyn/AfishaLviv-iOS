//
//  EventInfoTVC.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 27.03.12.

#import "ALViewController.h"

@class ALEvent;
@interface ALEventInfoViewController : ALViewController <UITableViewDelegate, UITableViewDataSource,
    UIWebViewDelegate>
@property (strong, nonatomic) ALEvent *event;
@end
