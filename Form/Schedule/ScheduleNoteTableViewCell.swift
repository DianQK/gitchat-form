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

    static func height(tableViewWidth: CGFloat, note: String) -> CGFloat {
        return note.withFont(UIFont.systemFont(ofSize: 17)).boundingRect(with: CGSize.init(width: tableViewWidth - 30, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).height + 43 + 15
    }

}
