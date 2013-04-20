//
//  PlaceCell.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.04.12.

#import "PlaceCell.h"

@implementation PlaceCell

#define DEFAULT_X 73
#define DEFAULT_WIDTH 197

@synthesize titleLabel = _titleLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize dkImageView = _dkImageView;

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_X, 5, DEFAULT_WIDTH, 30)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor]; // blueColor];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        _titleLabel.textAlignment = UITextAlignmentLeft;
        _titleLabel.numberOfLines = 2;
        //        
        //        CGSize sizeToFit = [_titleLabel.text sizeWithFont:_titleLabel.font];
        //        self.titleLabel.frame = CGRectMake(70, 5, sizeToFit.width/, sizeToFit.height);
        
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel
{
    if (_descriptionLabel == nil) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 37, 195, 50)];
        _descriptionLabel.textColor = [UIColor grayColor];
        _descriptionLabel.backgroundColor = [UIColor clearColor]; // greenColor];
        _descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        _descriptionLabel.textAlignment = UITextAlignmentLeft;
        _descriptionLabel.numberOfLines = 3;
        //        
        //        CGSize sizeToFit = [_titleLabel.text sizeWithFont:_titleLabel.font];
        //        self.titleLabel.frame = CGRectMake(70, 5, sizeToFit.width/, sizeToFit.height);
        
        [self addSubview:_descriptionLabel];
    }
    return _descriptionLabel;
}

- (DKImageView *)dkImageView
{
    if (_dkImageView == nil) {
        _dkImageView = [[DKImageView alloc] initWithStyle:DKImageViewStyleSmall];
        
        [self addSubview:_dkImageView];
    }
    return _dkImageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        [self addSubview:self.titleLabel];
        //        [self addSubview:self.placeLabel];
        //        [self addSubview:self.dkImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
