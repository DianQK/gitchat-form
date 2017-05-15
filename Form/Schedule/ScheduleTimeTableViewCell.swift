//
//  ScheduleTimeTableViewCell.swift
//  Form
//
//  Created by DianQK on 14/05/2017.
//  Copyright © 2017 t. All rights reserved.
//

import UIKit

class ScheduleTimeTableViewCell: ReactiveTableViewCell {

    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!

    static var height: CGFloat {
        return 80
    }

}
