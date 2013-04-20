//
//  DKImageView.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 23.03.12.

//

#import "DKImageView.h"
#import <QuartzCore/QuartzCore.h>


#define IMG_SMALL @"question-mark-small.png"
#define IMG_BIG @"question-mark-big.png"

#define IMG_SMALL_X 15
#define IMG_SMALL_Y 5
#define IMG_BIG_X 15
#define IMG_BIG_Y 5

#define IMG_SMALL_SCALE 0.9
#define IMG_BIG_SCALE 0.5

#define IMG_SMALL_WIDTH (IMG_SMALL_SCALE * 60)
#define IMG_SMALL_HEIGHT (IMG_SMALL_SCALE * 85) 
#define IMG_BIG_WIDTH (IMG_BIG_SCALE * 171)
#define IMG_BIG_HEIGHT (IMG_BIG_SCALE * 250)

@interface DKImageView()

@property (nonatomic) DKImageViewStyle imageStyle;

- (void)downloadImageFromUrl:(NSURL *)imageUrl;
- (BOOL)isExistsCachedImage:(NSURL *)imageUrl;
- (NSString *)imagesFolder;

@end

@implementation DKImageView

@synthesize imageStyle = _imageStyle;
@synthesize imageUrl = _imageUrl;

- (id)initWithStyle:(DKImageViewStyle)style
{
    self = [super init];
    if (self) {
        self.imageStyle = style;
        
        switch (style) {
            case DKImageViewStyleSmall:
                self.image = [UIImage imageNamed:IMG_SMALL];
                self.frame = CGRectMake(IMG_SMALL_X, IMG_SMALL_Y, IMG_SMALL_WIDTH, IMG_SMALL_HEIGHT);
                
                break;
            case DKImageViewStyleBig:
                self.image = [UIImage imageNamed:IMG_BIG];
                self.frame = CGRectMake(IMG_BIG_X, IMG_BIG_Y, IMG_BIG_WIDTH, IMG_BIG_HEIGHT);
                break;
            default:
                break;
        }
        
//        self.layer.cornerRadius = 5.0;
//        self.layer.masksToBounds = YES;
//        self.layer.borderColor = [[UIColor grayColor] CGColor];
//        self.layer.borderWidth = 1.0;
    }
    return self;
}

- (void)setImageUrl:(NSURL *)imageUrl
{
    switch (self.imageStyle) {
        case DKImageViewStyleSmall:
            self.image = [UIImage imageNamed:IMG_SMALL];
            self.frame = CGRectMake(IMG_SMALL_X, IMG_SMALL_Y, IMG_SMALL_WIDTH, IMG_SMALL_HEIGHT);
            break;
        case DKImageViewStyleBig:
            self.image = [UIImage imageNamed:IMG_BIG];
            self.frame = CGRectMake(IMG_BIG_X, IMG_BIG_Y, IMG_BIG_WIDTH, IMG_BIG_HEIGHT);
            break;
        default:
            break;
    }
    
//    self.layer.cornerRadius = 5.0;
//    self.layer.masksToBounds = YES;
//    self.layer.borderColor = [[UIColor grayColor] CGColor];
//    self.layer.borderWidth = 1.0;
    
    if ([self isExistsCachedImage:imageUrl] == NO) {
        [self downloadImageFromUrl:imageUrl];
    }
    else {
        self.image = [UIImage imageWithContentsOfFile:[self imagePathForImageUrl:imageUrl]];
    }
}

- (id)initWithImageFromUrl:(NSURL *)imageUrl style:(DKImageViewStyle)style
{
    self = [super init];
    if (self) {
        
        self.imageStyle = style;
        
        switch (style) {
            case DKImageViewStyleSmall:
                    self.image = [UIImage imageNamed:IMG_SMALL];
                    self.frame = CGRectMake(IMG_SMALL_X, IMG_SMALL_Y, IMG_SMALL_WIDTH, IMG_SMALL_HEIGHT);
                break;
            case DKImageViewStyleBig:
                self.image = [UIImage imageNamed:IMG_BIG];
                self.frame = CGRectMake(IMG_BIG_X, IMG_BIG_Y, IMG_BIG_WIDTH, IMG_BIG_HEIGHT);
                break;
            default:
                break;
        }
        
//        self.layer.cornerRadius = 5.0;
//        self.layer.masksToBounds = YES;
//        self.layer.borderColor = [[UIColor grayColor] CGColor];
//        self.layer.borderWidth = 1.0;
        
        if ([self isExistsCachedImage:imageUrl] == NO) {
            [self downloadImageFromUrl:imageUrl];
        }
        else {
            self.image = [UIImage imageWithContentsOfFile:[self imagePathForImageUrl:imageUrl]];
        }
    }
    return self;
}

+ (DKImageView *)imageViewWithImageFromUrl:(NSURL *)imageUrl style:(DKImageViewStyle)style
{
    return [[DKImageView alloc] initWithImageFromUrl:imageUrl style:style];
}

#pragma mark -
#pragma mark Logic

- (void)downloadImageFromUrl:(NSURL *)imageUrl
{
//    UIActivityIndicatorView *spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    spiner.frame = CGRectMake(self.center.x - spiner.frame.size.width, self.center.y - spiner.frame.size.height/2, spiner.frame.size.width, spiner.frame.size.height);
//    [self addSubview:spiner];
//    [spiner startAnimating];
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (imageData != nil) {
                self.image = [UIImage imageWithData:imageData];
                [[NSFileManager defaultManager] createFileAtPath:[self imagePathForImageUrl:imageUrl] 
                                                        contents:imageData attributes:nil];
            }
//            [spiner stopAnimating];
//            [spiner removeFromSuperview];
        });
    });
}

- (BOOL)isExistsCachedImage:(NSURL *)imageUrl
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self imagePathForImageUrl:imageUrl]];
}

- (NSString *)imagePathForImageUrl:(NSURL *)imageUrl
{
    return [[self imagesFolder] stringByAppendingFormat:@"/%@", [[imageUrl pathComponents] lastObject]];
}

- (NSString *)imagesFolder
{
    NSString *imagesFolder;
    
    switch (self.imageStyle) {
        case DKImageViewStyleSmall:
            imagesFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/small_imgs/"];
            break;
        case DKImageViewStyleBig:
            imagesFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/big_imgs/"];
            break;
        default:
            break;
    }
    
    BOOL imagesFolderExists = [[NSFileManager defaultManager] fileExistsAtPath:imagesFolder];
    if (imagesFolderExists == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:imagesFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return imagesFolder;
}

@end