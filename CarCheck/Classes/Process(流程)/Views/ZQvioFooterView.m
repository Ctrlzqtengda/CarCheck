//
//  ZqvioFooterView.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/31.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQvioFooterView.h"
#import <Masonry.h>

@interface ZQvioFooterView()

@property(strong,nonatomic)UIButton *btn;
@property(strong,nonatomic)UILabel *agreeLabel;
@property(strong,nonatomic)UIButton *protocolBtn;

@end

@implementation ZQvioFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

-(void)initViews {
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.btn];
//    self.btn.layer.cornerRadius = 3;
    [self.btn setImage:[UIImage imageNamed:@"unAgree"] forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateSelected];
    [self.btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.btn.backgroundColor = [UIColor redColor];
    
    self.agreeLabel = [[UILabel alloc] init];
    self.agreeLabel.text = @"我已阅读并同意";
    self.agreeLabel.textColor = [UIColor lightGrayColor];
    self.agreeLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.agreeLabel];
    
    self.protocolBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.protocolBtn];
    [self.protocolBtn addTarget:self action:@selector(clickKnowAction:) forControlEvents:UIControlEventTouchUpInside];
    self.protocolBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.protocolBtn setTitle:@"《新概念检车罚款代缴服务须知》" forState:(UIControlStateNormal)];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"订单合计";
    label.font = [UIFont systemFontOfSize:18.0];
    [self addSubview:label];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(15);
//        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.width.equalTo(@20);
        make.height.equalTo(self.btn.mas_width).offset(0);
        
    }];
    
    [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.btn.mas_top).offset(0);
        make.left.equalTo(self.btn.mas_right).offset(5);
        make.width.equalTo(@95);
        make.height.equalTo(self.btn.mas_width).offset(0);
        
    }];
    
    [self.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.btn.mas_top).offset(0);
        make.left.equalTo(self.agreeLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(10);
        make.height.equalTo(self.btn.mas_width).offset(0);
        
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.btn.mas_left).offset(0);
//        make.top.equalTo(self.contentView.mas_bottomMargin).offset(0);
        make.top.equalTo(self.btn.mas_bottom).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(10);
        make.height.equalTo(self.btn.mas_width).offset(0);
        
    }];
    
//    self.agreeLabel = [uila]
}

// 是否同意按钮
-(void)clickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(agreeAction:)]) {
        [self.delegate agreeAction:sender.selected];
    }
    
}

// 须知按钮
-(void)clickKnowAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(knowProtocolAction:)]) {
        [self.delegate knowProtocolAction:sender];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
