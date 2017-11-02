//
//  ZQVioUpTableViewCell.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/31.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQVioUpTableViewCell.h"

@interface ZQVioUpTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *provinceCodeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftInset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfRightInset;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;

@end

@implementation ZQVioUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

-(void)setIsCarCode:(BOOL )isCarCode {
    
    _isCarCode = isCarCode;
    if (_isCarCode) {
        self.titleLabel.backgroundColor = [UIColor redColor];
        self.imgView.hidden = NO;
        self.provinceCodeLabel.hidden = NO;
        self.leftInset.constant = 80.0;
    }else{
        self.leftInset.constant = 8.0;
        self.imgView.hidden = YES;
        self.provinceCodeLabel.hidden = YES;
    }
}

-(void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

-(void)setPalceText:(NSString *)palceText {
    _palceText = palceText;
    self.contentTf.placeholder = palceText;
}

-(void)setCellType:(ZqCellType )type title:(NSString *)title placeText:(NSString *)placeText {
    
    self.title = title;
    self.palceText = placeText;
    switch (type) {
            // 车牌号
        case ZQVioUpCellType1:
            self.imgView.hidden = NO;
            self.provinceCodeLabel.hidden = NO;
            self.leftInset.constant = 80.0;
            self.contentTf.enabled = YES;
            self.tfRightInset.constant = 8;
            self.rightImgView.hidden = YES;
            break;
            // 能输入，字在左边
        case ZQVioUpCellType2:
            self.leftInset.constant = 8.0;
            self.imgView.hidden = YES;
            self.provinceCodeLabel.hidden = YES;
            self.contentTf.enabled = YES;
            self.contentTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.tfRightInset.constant = 8;
            self.rightImgView.hidden = YES;
            break;
            // 不能输入
        case ZQVioUpCellType3:
            self.leftInset.constant = 8.0;
            self.imgView.hidden = YES;
            self.provinceCodeLabel.hidden = YES;
            self.contentTf.enabled = NO;
            self.tfRightInset.constant = 48;
            self.rightImgView.hidden = NO;
            break;
            
        case ZQVioUpCellType4:
            // 第二分组
            self.leftInset.constant = 8.0;
            self.imgView.hidden = YES;
            self.provinceCodeLabel.hidden = YES;
            self.contentTf.enabled = YES;
            self.tfRightInset.constant = 8;
            self.rightImgView.hidden = YES;
            self.contentTf.enabled = NO;
            self.contentTf.textAlignment = NSTextAlignmentRight;
            break;
            // 能输入,字在右边
        case ZQVioUpCellType5:
            self.leftInset.constant = 8.0;
            self.imgView.hidden = YES;
            self.provinceCodeLabel.hidden = YES;
            self.contentTf.enabled = YES;
            self.contentTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.tfRightInset.constant = 8;
            self.rightImgView.hidden = YES;
            self.contentTf.textAlignment = NSTextAlignmentRight;
            break;
        default:
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
