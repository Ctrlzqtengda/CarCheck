//
//  ZQMyBooingCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMyBooingCell.h"

@interface ZQMyBooingCell()
{
    CGFloat xMagin;
    CGFloat labelWidth;
    CGFloat fontSize;
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *btnBgView;
@property (nonatomic, strong) UILabel *bookingTitleL;

@property (nonatomic, strong) UILabel *bookingTimeL;

@property (nonatomic, strong) UILabel *contactL;

@property (nonatomic, strong) UILabel *phoneL;
@property (nonatomic, strong) UILabel *prepaidAmountL;
@end

@implementation ZQMyBooingCell

+ (CGFloat)myBooingCellHeight
{
    return 207;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        fontSize = 14;
        xMagin = 10;
        labelWidth = __kWidth - 2*xMagin;
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.btnBgView];
        [self.bgView addSubview:self.bookingTitleL];
        [self.bgView addSubview:self.bookingTimeL];
        [self.bgView addSubview:self.contactL];
        [self.bgView addSubview:self.phoneL];
        [self.bgView addSubview:self.prepaidAmountL];
        [self.btnBgView addSubview:self.agencyDetailBtn];
        [self.btnBgView addSubview:self.endorseBtn];
    }
    
    return self;
}

- (void)setOrderModel:(ZQOrderModel *)orderModel
{
    if ([_orderModel isEqual:orderModel]) {
        return;
    }
    _orderModel = orderModel;
    if (_orderModel.type.integerValue==1) {
        [self.bookingTitleL setText:[NSString stringWithFormat:@"预约项目: %@",@"自行上线检车"]];
    }
    else
    {
        [self.bookingTitleL setText:[NSString stringWithFormat:@"预约项目: %@",@"上门接送检车"]];
    }
    [self.bookingTimeL setText:[NSString stringWithFormat:@"预约时间: %@",_orderModel.u_date]];
    [self.contactL setText:[NSString stringWithFormat:@"联  系  人: %@",_orderModel.u_name]];
    [self.phoneL setText:[NSString stringWithFormat:@"联系电话: %@",_orderModel.u_phone]];
    
    if (!_orderModel.pay_money) {
        _orderModel.pay_money = @"0";
    }
    NSString *moneyStr = [NSString stringWithFormat:@"预付金额: ￥%@",_orderModel.pay_money];
    NSRange range = [moneyStr rangeOfString:[NSString stringWithFormat:@"￥%@",_orderModel.pay_money]];
    NSMutableAttributedString *attachStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attachStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [self.prepaidAmountL setAttributedText:attachStr];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 3, __kWidth-2*8, 120)];
        _bgView.backgroundColor = MainBgColor;
    }
    return _bgView;
}

- (UIView *)btnBgView
{
    if (!_btnBgView) {
        _btnBgView = [[UIView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_bgView.frame)+5, CGRectGetWidth(_bgView.frame), 70)];
        _btnBgView.backgroundColor = MainBgColor;
    }
    return _btnBgView;
}

- (UILabel *)bookingTitleL
{
    if (!_bookingTitleL) {
        _bookingTitleL = [[UILabel alloc] initWithFrame:CGRectMake(xMagin, 10,labelWidth, 20)];
        _bookingTitleL.font = [UIFont systemFontOfSize:fontSize];
        _bookingTitleL.textColor = [UIColor darkTextColor];
    }
    return _bookingTitleL;
}
- (UILabel *)bookingTimeL
{
    if (!_bookingTimeL) {
        _bookingTimeL = [[UILabel alloc] initWithFrame:CGRectMake(xMagin, CGRectGetMaxY(_bookingTitleL.frame), labelWidth, 20)];
        _bookingTimeL.font = [UIFont systemFontOfSize:fontSize];
        _bookingTimeL.textColor = [UIColor darkGrayColor];
    }
    return _bookingTimeL;
}
- (UILabel *)contactL
{
    if (!_contactL) {
        _contactL = [[UILabel alloc] initWithFrame:CGRectMake(xMagin, CGRectGetMaxY(_bookingTimeL.frame), labelWidth, 20)];
        _contactL.font = [UIFont systemFontOfSize:fontSize];
        _contactL.textColor = [UIColor darkGrayColor];
    }
    return _contactL;
}
- (UILabel *)phoneL
{
    if (!_phoneL) {
        _phoneL = [[UILabel alloc] initWithFrame:CGRectMake(xMagin, CGRectGetMaxY(_contactL.frame), labelWidth, 20)];
        _phoneL.font = [UIFont systemFontOfSize:fontSize];
        _phoneL.textColor = [UIColor darkGrayColor];
    }
    return _phoneL;
}
- (UILabel *)prepaidAmountL
{
    if (!_prepaidAmountL) {
        _prepaidAmountL = [[UILabel alloc] initWithFrame:CGRectMake(xMagin, CGRectGetMaxY(_phoneL.frame), labelWidth, 20)];
        _prepaidAmountL.font = [UIFont systemFontOfSize:fontSize];
        _prepaidAmountL.textColor = [UIColor darkGrayColor];
    }
    return _prepaidAmountL;
}

- (UIButton *)agencyDetailBtn
{
    if (!_agencyDetailBtn) {
        _agencyDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agencyDetailBtn setFrame:CGRectMake((CGRectGetWidth(_btnBgView.frame)-100*2)/3, (CGRectGetHeight(_btnBgView.frame)-30)/2,100, 30)];
        _agencyDetailBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_agencyDetailBtn setTitle:@"机构详情" forState:UIControlStateNormal];
        [_agencyDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_agencyDetailBtn setBackgroundColor:LH_RGBCOLOR(17,149,232)];
        _agencyDetailBtn.layer.cornerRadius = 6;
    }
    return _agencyDetailBtn;
}
- (UIButton *)endorseBtn
{
    if (!_endorseBtn) {
        _endorseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_endorseBtn setFrame:CGRectMake(CGRectGetMaxX(_agencyDetailBtn.frame)+CGRectGetMinX(_agencyDetailBtn.frame), CGRectGetMinY(_agencyDetailBtn.frame),CGRectGetWidth(_agencyDetailBtn.frame), 30)];
        _endorseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_endorseBtn setTitle:@"改签订单" forState:UIControlStateNormal];
        [_endorseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_endorseBtn setBackgroundColor:LH_RGBCOLOR(17,149,232)];
        _endorseBtn.layer.cornerRadius = 6;
    }
    return _endorseBtn;
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
