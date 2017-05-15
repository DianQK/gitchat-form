//
//  ScheduleNoteTableViewCell.swift
//  Form
//
//  Created by DianQK on 15/05/2017.
//  Copyright © 2017 t. All rights reserved.
//

import UIKit

class ScheduleNoteTableViewCell: ReactiveTableViewCell {

    @IBOutlet weak var noteTextLabel: UILabel!

    static func height(note: String) -> CGFloat {
        return 80
    }

}
