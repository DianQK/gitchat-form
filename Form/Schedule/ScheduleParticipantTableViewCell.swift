//
//  ScheduleParticipantTableViewCell.swift
//  Form
//
//  Created by DianQK on 14/05/2017.
//  Copyright © 2017 t. All rights reserved.
//

import UIKit

class ScheduleParticipantItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!


}

class ScheduleParticipantCollectionView: UICollectionView {



}

class ScheduleParticipantTableViewCell: ReactiveTableViewCell {

    @IBOutlet weak var collectionView: ScheduleParticipantCollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func height(memberCount: Int) -> CGFloat {
        return 200
    }

}
