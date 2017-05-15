//
//  ScheduleTextInputTableViewCell.swift
//  Form
//
//  Created by DianQK on 14/05/2017.
//  Copyright © 2017 t. All rights reserved.
//

import UIKit

class ScheduleTextInputTableViewCell: ReactiveTableViewCell {

    @IBOutlet weak var textField: UITextField!

    static var height: CGFloat {
        return 50
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = ""
        textField.placeholder = ""
    }

}
