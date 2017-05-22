//
//  ScheduleParticipantTableViewCell.swift
//  Form
//
//  Created by DianQK on 14/05/2017.
//  Copyright © 2017 t. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ScheduleParticipantItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!


}

class ScheduleParticipantCollectionView: UICollectionView {



}

class ScheduleParticipantTableViewCell: ReactiveTableViewCell {

    @IBOutlet weak var collectionView: ScheduleParticipantCollectionView!
    
    typealias Section = SectionModel<(), Member?>
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<Section>()
    
    let selectedMembers = Variable<[Member]>([])
    
    let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.isScrollEnabled = false
        
        dataSource.configureCell = { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.scheduleParticipantItemCollectionViewCell, for: indexPath)!
            cell.imageView.image = item?.avatar ?? UIImage()
            cell.nameLabel.text = item?.name ?? "+"
            return cell
        }
        
        selectedMembers.asDriver()
            .map { [Section(model: (), items: $0 + [nil])] }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }
    
    var addMember: ControlEvent<()> {
        let source = self.collectionView.rx.modelSelected(Member?.self)
            .flatMap { (member) -> Observable<()> in
                if member == nil {
                    return Observable.just(())
                } else {
                    return Observable.empty()
                }
        }
        return ControlEvent(events: source)
    }

    static func height(memberCount: Int) -> CGFloat {
        return CGFloat((memberCount / 5 + 1) * 80 - 10) + 57
    }

}
