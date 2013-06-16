//
//  ALViewController.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 6/15/13.
//
//

#import "ALViewController.h"

@interface ALViewController ()

@end

@implementation ALViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNib
{
    NSString *nibName = [[self class] description];
    
    // if iPhone 5
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        NSString *nibName568 = [nibName stringByAppendingString:@"568"];
        NSString *nib568Path = [[NSBundle mainBundle] pathForResource:nibName568 ofType:@"nib"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:nib568Path]) {
            nibName = nibName568;
        }
    }

    return [self initWithNibName:nibName bundle:nil];
}

+ (id)controller
{
    return [[[self class] alloc] initWithNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
