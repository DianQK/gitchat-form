//
//  SelectButton.swift
//  Form
//
//  Created by wc on 2017/5/7.
//  Copyright © 2017年 t. All rights reserved.
//

import UIKit

public class SelectButton: UIButton {

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.setTitle("已选择", for: .selected)
        self.setTitle("未选择", for: .normal)
        
    }

}
