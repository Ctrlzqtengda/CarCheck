//
//  ZQInspectionCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

const CGFloat cSpace =  6;

#import "ZQInspectionCell.h"
#import "UIImageView+WebCache.h"

@interface ZQInspectionCell ()
{
    CGFloat labelWidth;
    CGFloat labelHeight;
    CGFloat font_size;
}
@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UIImageView *unUseImageV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UILabel *phoneDesL;

@property (nonatomic, strong) UILabel *addressLabel;

//@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *phoneBtn;

@property (nonatomic, strong) UIImageView *starBgImg;

@property (nonatomic, strong) UILabel *linkmanDesLabel;

@property (nonatomic, strong) UILabel *linkmanLabel;

@end

@implementation ZQInspectionCell

+ (CGFloat)inspectionCellHeight
{
    if (__kWidth>320) { 
        return 160;
    }
    return 140;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        font_size = 13;
        labelWidth = 36;
        labelHeight = 18;
        [self.contentView addSubview:self.imgV];
        [self.imgV addSubview:self.unUseImageV];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.distanceLabel];
        [self.contentView addSubview:self.addressLabel];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cSpace, CGRectGetMinY(_addressLabel.frame), labelWidth, labelHeight)];
        label.font = [UIFont systemFontOfSize:font_size];
        label.text = @"地址:";
        label.textColor = LH_RGBCOLOR(17,149,232);
        [self.contentView addSubview:label];
        
//        [self.contentView addSubview:self.linkmanDesLabel];
//        [self.contentView addSubview:self.linkmanLabel];
//        [self.contentView addSubview:self.phoneDesL];
//        [self.contentView addSubview:self.phoneLabel];
//        [self.contentView addSubview:self.phoneBtn];
        [self.contentView addSubview:self.navigationBtn];
        [self.contentView addSubview:self.bookingBtn];
    }
    
    return self;
}

- (void)setInspectionModel:(ZQInspectionModel *)inspectionModel
{
    if ([_inspectionModel isEqual:inspectionModel]) {
        return;
    }
    _inspectionModel = inspectionModel;
    if ([_inspectionModel.logo isKindOfClass:[NSString class]]) {
        if (_inspectionModel.logo.length) {
            [self.imgV sd_setImageWithURL:[NSURL URLWithString:_inspectionModel.logo] placeholderImage:[UIImage imageNamed:@"agency"]];
        }
    }
    else
    {
        [self.imgV setImage:[UIImage imageNamed:@"agency"]];
    }
    [self.titleLabel setText:_inspectionModel.o_name];
    NSInteger meter = _inspectionModel.meter.integerValue;
    if (meter > 0) {
        [self.distanceLabel setText:[NSString stringWithFormat:@"%ldkm",(long)meter]];
    }
    else
    {
        [self.distanceLabel setText:@"0km"];
    }
    NSString *addressStr = _inspectionModel.o_where;
    CGRect rect = self.addressLabel.frame;
    self.addressLabel.frame = rect;
    [self.addressLabel setText:addressStr];
    
    /*
    NSString *linkmanStr = _inspectionModel.contact_name;
    rect = self.linkmanDesLabel.frame;
    rect.origin.y = CGRectGetMaxY(self.addressLabel.frame);
    self.linkmanDesLabel.frame = rect;
    
    rect = self.linkmanLabel.frame;
    rect.origin.y = CGRectGetMaxY(self.addressLabel.frame);
    self.linkmanLabel.frame = rect;
    [self.linkmanLabel setText:linkmanStr];
    
    rect = self.phoneDesL.frame;
    rect.origin.y = CGRectGetMaxY(self.linkmanLabel.frame);
    self.phoneDesL.frame = rect;
    
    NSString *phoneStr = _inspectionModel.o_phone;
    //    rect = self.phoneLabel.frame;
    rect = self.phoneBtn.frame;
    rect.origin.y = CGRectGetMinY(self.phoneDesL.frame);
    self.phoneBtn.frame = rect;
    [self.phoneBtn setTitle:phoneStr forState:UIControlStateNormal];
     */
    if (_inspectionModel.type.integerValue==1)
    {
        [self.unUseImageV setHidden:YES];
    }
    else
    {
        [self.unUseImageV setHidden:NO];
    }
}

- (void)phoneBtnAction:(UIButton *)sender
{
    if (_inspectionModel.type.integerValue==1)
    {
        NSString *phoneStr = sender.titleLabel.text;
        NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
        UIApplication * app = [UIApplication sharedApplication];
        if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
            [app openURL:[NSURL URLWithString:PhoneStr]];
        }
        return;
    }
    [ZQLoadingView showAlertHUD:@"此机构暂未开通业务敬请期待！" duration:2.0];
}
- (UIImageView *)imgV
{
    if (!_imgV) {
        CGFloat imageW =  __kWidth*176/750;
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,imageW,imageW)];
//        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,imageW, [ZQInspectionCell inspectionCellHeight]-20)];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.layer.masksToBounds = YES;
    }
    return _imgV;
}

- (UIImageView *)unUseImageV
{
    if (!_unUseImageV) {
//        CGFloat imageW =  __kWidth*176/750;
        UIImage *image = [UIImage imageNamed:@"unUse"];
        _unUseImageV = [[UIImageView alloc] initWithImage:image];
        //        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,imageW, [ZQInspectionCell inspectionCellHeight]-20)];
        _unUseImageV.contentMode = UIViewContentModeScaleAspectFill;
        _unUseImageV.layer.masksToBounds = YES;
    }
    return _unUseImageV;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cSpace, 10, __kWidth-CGRectGetMaxX(_imgV.frame)-cSpace*2-50, 20)];
//         _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cSpace, 10, __kWidth-CGRectGetMaxX(_imgV.frame)-cSpace*2, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}
- (UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame), 10, __kWidth-CGRectGetMaxX(_titleLabel.frame)-5, 20)];
        _distanceLabel.font = [UIFont systemFontOfSize:13];
        _distanceLabel.textColor = [UIColor darkGrayColor];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _distanceLabel;
}
- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cSpace+labelWidth, CGRectGetMaxY(_titleLabel.frame)+2, __kWidth-CGRectGetMaxX(_imgV.frame)-cSpace-labelWidth, labelHeight)];
        _addressLabel.font = [UIFont systemFontOfSize:font_size];
        _addressLabel.numberOfLines = 2;
    }
    return _addressLabel;
}
- (UILabel *)phoneDesL
{
    if (!_phoneDesL) {
        _phoneDesL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cSpace, CGRectGetMaxY(_addressLabel.frame), labelWidth, labelHeight)];
        _phoneDesL.font = [UIFont systemFontOfSize:font_size];
        _phoneDesL.text = @"电话:";
        _phoneDesL.textColor = LH_RGBCOLOR(17,149,232);
    }
    return _phoneDesL;
}
//- (UILabel *)phoneLabel
//{
//    if (!_phoneLabel) {
//        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_addressLabel.frame), CGRectGetMaxY(_addressLabel.frame), CGRectGetWidth(_addressLabel.frame), 34)];
//        _phoneLabel.font = [UIFont systemFontOfSize:14];
//        _phoneLabel.numberOfLines = 2;
//    }
//    return _phoneLabel;
//}
- (UIButton *)phoneBtn
{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneBtn setFrame:CGRectMake(CGRectGetMinX(_addressLabel.frame), CGRectGetMaxY(_addressLabel.frame), CGRectGetWidth(_addressLabel.frame), labelHeight)];
        _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:font_size];
        [_phoneBtn setTitleColor:LH_RGBCOLOR(17,149,232) forState:UIControlStateNormal];
        [_phoneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_phoneBtn addTarget:self action:@selector(phoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}
- (UILabel *)linkmanDesLabel
{
    if (!_linkmanDesLabel) {
        _linkmanDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cSpace, CGRectGetMaxY(_addressLabel.frame), labelWidth+15, labelHeight)];
        _linkmanDesLabel.font = [UIFont systemFontOfSize:font_size];
        _linkmanDesLabel.text = @"联系人:";
        _linkmanDesLabel.textColor = LH_RGBCOLOR(17,149,232);
    }
    return _linkmanDesLabel;
}
- (UILabel *)linkmanLabel
{
    if (!_linkmanLabel) {
        _linkmanLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_addressLabel.frame)+15, CGRectGetMaxY(_addressLabel.frame), CGRectGetWidth(_addressLabel.frame), labelHeight)];
        _linkmanLabel.font = [UIFont systemFontOfSize:font_size];
    }
    return _linkmanLabel;
}
- (UIButton *)navigationBtn
{
    if (!_navigationBtn) {
        CGFloat btnWidth = 100;
        _navigationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_navigationBtn setFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cSpace, CGRectGetMaxY(_phoneLabel.frame),(CGRectGetWidth(_addressLabel.frame)-10+labelWidth)/2, 30)];
        [_navigationBtn setFrame:CGRectMake((__kWidth-btnWidth*2)/3, [ZQInspectionCell inspectionCellHeight]-40,btnWidth, 30)];
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
//        [_bookingBtn setFrame:CGRectMake(CGRectGetMaxX(_navigationBtn.frame)+10, CGRectGetMaxY(_phoneLabel.frame),CGRectGetWidth(_navigationBtn.frame), 30)];
        [_bookingBtn setFrame:CGRectMake(CGRectGetMaxX(_navigationBtn.frame)+CGRectGetMinX(_navigationBtn.frame), CGRectGetMinY(_navigationBtn.frame),CGRectGetWidth(_navigationBtn.frame), 30)];
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
/*
 - (void)setInfoDict:(NSDictionary *)infoDict
 {
 if ([_infoDict isEqual:infoDict]) {
 return;
 }
 _infoDict = infoDict;
 [self.imgV setImage:[UIImage imageNamed:infoDict[@"image"]]];
 [self.titleLabel setText:infoDict[@"name"]];
 [self.distanceLabel setText:infoDict[@"distance"]];
 
 //    NSString *addressStr = [NSString stringWithFormat:@"地址: %@",infoDict[@"address"]];
 //    NSRange range = [addressStr rangeOfString:@"地址:"];
 //    NSMutableAttributedString *attachStr = [[NSMutableAttributedString alloc] initWithString:addressStr];
 //    [attachStr addAttribute:NSForegroundColorAttributeName value:LH_RGBCOLOR(17,149,232) range:range];
 //    [self.addressLabel setAttributedText:attachStr];
 NSString *addressStr = infoDict[@"address"];
 CGRect rect = self.addressLabel.frame;
 //   CGSize size = [addressStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
 //    if (size.width>CGRectGetWidth(self.addressLabel.frame)) {
 //        rect.size.height = 34;
 //    }
 //    else
 //    {
 //        rect.size.height = labelHeight;
 //    }
 self.addressLabel.frame = rect;
 [self.addressLabel setText:addressStr];
 
 NSString *linkmanStr = infoDict[@"linkman"];
 rect = self.linkmanDesLabel.frame;
 rect.origin.y = CGRectGetMaxY(self.addressLabel.frame);
 self.linkmanDesLabel.frame = rect;
 
 rect = self.linkmanLabel.frame;
 rect.origin.y = CGRectGetMaxY(self.addressLabel.frame);
 self.linkmanLabel.frame = rect;
 [self.linkmanLabel setText:linkmanStr];
 
 rect = self.phoneDesL.frame;
 rect.origin.y = CGRectGetMaxY(self.linkmanLabel.frame);
 self.phoneDesL.frame = rect;
 
 NSString *phoneStr = infoDict[@"phone"];
 //    rect = self.phoneLabel.frame;
 rect = self.phoneBtn.frame;
 rect.origin.y = CGRectGetMinY(self.phoneDesL.frame);
 //    size = [phoneStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
 //    rect.size.height = size.height;
 //    if (size.height>34) {
 //        rect.size.height = 34;
 //    }
 
 //    if (size.width>CGRectGetWidth(self.phoneLabel.frame)) {
 //        rect.size.height = 34;
 //    }
 //    else
 //    {
 //        rect.size.height = 15;
 //    }
 //    self.phoneLabel.frame = rect;
 //    [self.phoneLabel setText:phoneStr];
 self.phoneBtn.frame = rect;
 [self.phoneBtn setTitle:phoneStr forState:UIControlStateNormal];
 
 //    NSString *phoneStr = [NSString stringWithFormat:@"电话: %@",infoDict[@"phone"]];
 //    range = [phoneStr rangeOfString:@"电话:"];
 //    attachStr = [[NSMutableAttributedString alloc] initWithString:phoneStr];
 //    [attachStr addAttribute:NSForegroundColorAttributeName value:LH_RGBCOLOR(17,149,232) range:range];
 //    [self.phoneLabel setAttributedText:attachStr];
 }
 */
@end
