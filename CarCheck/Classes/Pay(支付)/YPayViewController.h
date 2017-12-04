//
//  YPayViewController.h
//  shopsN
//
//  Created by imac on 2016/12/23.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import "BaseViewController.h"

@interface YPayViewController : BaseViewController

/**支付json*/
@property (strong,nonatomic) NSDictionary *payJson;
/**订单id*/
@property (copy,nonatomic) NSString *orderId;
/**金额*/
@property (copy, nonatomic) NSString *payMoney;
/**订单名称*/
@property (copy,nonatomic) NSString *orderName;

//@property (strong,nonatomic) YAddressModel *addressModel;

@end
