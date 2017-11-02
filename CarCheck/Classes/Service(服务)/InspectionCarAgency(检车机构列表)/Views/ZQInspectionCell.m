//
//  ZQInspectionCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

const CGFloat cSpace =  8;

#import "ZQInspectionCell.h"

@interface ZQInspectionCell ()

@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UIImageView *starBgImg;

@end

@implementation ZQInspectionCell

+ (CGFloat)inspectionCellHeight
{
    return 140;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.imgV];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.distanceLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.navigationBtn];
        [self.contentView addSubview:self.bookingBtn];
    }
    
    return self;
}


- (void)setInfoDict:(NSDictionary *)infoDict
{
    [self.imgV setImage:[UIImage imageNamed:infoDict[@"image"]]];
    [self.titleLabel setText:infoDict[@"name"]];
    [self.distanceLabel setText:infoDict[@"distance"]];
    
    NSString *addressStr = [NSString stringWithFormat:@"地址: %@",infoDict[@"address"]];
    NSRange range = [addressStr rangeOfString:@"地址:"];
    NSMutableAttributedString *attachStr = [[NSMutableAttributedString alloc] initWithString:addressStr];
    [attachStr addAttribute:NSForegroundColorAttributeName value:LH_RGBCOLOR(17,149,232) range:range];
    [self.addressLabel setAttributedText:attachStr];
    
   CGSize size = [addressStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    if (size.width>CGRectGetWidth(self.addressLabel.frame)) {
        [self.addressLabel sizeToFit];
    }
    else
    {
        self.addressLabel.font = [UIFont systemFontOfSize:14];
    }
    NSString *phoneStr = [NSString stringWithFormat:@"电话: %@",infoDict[@"phone"]];
    range = [phoneStr rangeOfString:@"电话:"];
    attachStr = [[NSMutableAttributedString alloc] initWithString:phoneStr];
    [attachStr addAttribute:NSForegroundColorAttributeName value:LH_RGBCOLOR(17,149,232) range:range];
    [self.phoneLabel setAttributedText:attachStr];
}
- (UIImageView *)imgV
{
    if (!_imgV) {
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, __kWidth*300/750, [ZQInspectionCell inspectionCellHeight]-20)];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.layer.masksToBounds = YES;
    }
    return _imgV;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cSpace, 10, __kWidth-CGRectGetMaxX(_imgV.frame)-cSpace*2-40, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}
- (UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame), 10, 40, 20)];
        _distanceLabel.font = [UIFont systemFontOfSize:13];
        _distanceLabel.textColor = [UIColor darkGrayColor];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _distanceLabel;
}
- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cSpace, CGRectGetMaxY(_titleLabel.frame), __kWidth-CGRectGetMaxX(_imgV.frame)-cSpace*2, 30)];
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}
- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cSpace, CGRectGetMaxY(_addressLabel.frame), CGRectGetWidth(_addressLabel.frame), 40)];
        _phoneLabel.font = [UIFont systemFontOfSize:14];
        _phoneLabel.numberOfLines = 0;
    }
    return _phoneLabel;
}
- (UIButton *)navigationBtn
{
    if (!_navigationBtn) {
        _navigationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navigationBtn setFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cSpace, CGRectGetMaxY(_phoneLabel.frame),(CGRectGetWidth(_addressLabel.frame)-10)/2, 30)];
        _navigationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_navigationBtn setImage:[UIImage imageNamed:@"naviIcon"] forState:UIControlStateNormal];
        [_navigationBtn setTitle:@"导航到点" forState:UIControlStateNormal];
        [_navigationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_navigationBtn setBackgroundColor:LH_RGBCOLOR(17,149,232)];
        _navigationBtn.layer.cornerRadius = 4;
    }
    return _navigationBtn;
}
- (UIButton *)bookingBtn
{
    if (!_bookingBtn) {
        _bookingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bookingBtn setFrame:CGRectMake(CGRectGetMaxX(_navigationBtn.frame)+5, CGRectGetMaxY(_phoneLabel.frame),CGRectGetWidth(_navigationBtn.frame), 30)];
        _bookingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_bookingBtn setTitle:@"立即预约" forState:UIControlStateNormal];
        [_bookingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bookingBtn setBackgroundColor:LH_RGBCOLOR(12,189,49)];
        _bookingBtn.layer.cornerRadius = 4;
    }
    return _bookingBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
