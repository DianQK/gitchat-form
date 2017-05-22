//
//  ScheduleDeleteParticipantsViewController.swift
//  Form
//
//  Created by wc on 2017/5/20.
//  Copyright © 2017年 t. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyAttributes
import RbSwift
import NotificationBannerSwift

extension Member: IdentifiableType {
    
    var identity: Int64 {
        return self.id
    }
    
}

class ScheduleDeleteParticipantsViewController: UIViewController {
    
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    typealias Section = AnimatableSectionModel<String, Member>
    
    let selectedMembers = Variable<[Member]>([])
    let dataSource = RxTableViewSectionedAnimatedDataSource<Section>()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)

        dataSource.configureCell = { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.participantsCell, for: indexPath)!
            cell.selectionStyle = .none
            cell.imageView?.image = item.avatar
            cell.textLabel?.text = item.name
            return cell
        }
        
        dataSource.canEditRowAtIndexPath = { _ in true }
        
        tableView.setEditing(true, animated: false)
        
        tableView.rx.itemDeleted.map { [unowned self] in self.dataSource[$0] }
            .subscribe(onNext: { [unowned self] member in
                if let index = self.selectedMembers.value.index(member) {
                    self.selectedMembers.value.remove(at: index)
                }
            })
            .disposed(by: disposeBag)
        
        selectedMembers.asDriver()
            .map { [Section(model: "", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }

}

extension Reactive where Base: ScheduleDeleteParticipantsViewController {
    
    static func createScheduleDeleteParticipants(selectedMembers: [Member], parent: UIViewController) -> Observable<ScheduleDeleteParticipantsViewController> {
        return Observable.create { [weak parent] (observer) -> Disposable in
            let scheduleDeleteParticipantsViewController = R.storyboard.main.scheduleDeleteParticipantsViewController()!
            scheduleDeleteParticipantsViewController.selectedMembers.value = selectedMembers
            let nav = UINavigationController(rootViewController: scheduleDeleteParticipantsViewController)
            _ = scheduleDeleteParticipantsViewController.view
            parent?.present(nav, animated: true, completion: nil)
            observer.onNext(scheduleDeleteParticipantsViewController)
            
            
            return Disposables.create {
                scheduleDeleteParticipantsViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    var ensure: Observable<[Member]> {
        _ = self.base.view
        return self.base.doneBarButtonItem.rx.tap.asObservable()
            .withLatestFrom(self.base.selectedMembers.asObservable())
    }
    
}
