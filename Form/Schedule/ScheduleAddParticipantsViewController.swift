//
//  ScheduleAddParticipantsViewController.swift
//  Form
//
//  Created by DianQK on 15/05/2017.
//  Copyright © 2017 t. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyAttributes
import RbSwift
import NotificationBannerSwift

class ScheduleAddParticipantsViewController: UIViewController {

    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    typealias Section = SectionModel<(), Member>

    var selectedMembers: [Member] = []
    let addedMembers = Variable<[Member]>([])
    let dataSource = RxTableViewSectionedReloadDataSource<Section>()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configureCell = { [unowned self] dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.participantsCell, for: indexPath)!
            if self.selectedMembers.contains(item) {
                cell.accessoryType = .checkmark
                cell.selectionStyle = .none
            } else {
                cell.selectionStyle = .default
                self.addedMembers.asObservable()
                    .map { $0.contains(item) }
                    .map { $0 ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none }
                    .bind(to: cell.rx.accessoryType)
                    .disposed(by: cell.reuseDisposeBag)
            }
            cell.imageView?.image = item.avatar
            cell.textLabel?.text = item.name
            return cell
        }
        
        Observable.just(Member.members)
            .map { [Section(model: (), items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Member.self)
            .filter { [unowned self] in !self.selectedMembers.contains($0) }
            .subscribe(onNext: { [unowned self] member in
                if let index = self.addedMembers.value.index(member) {
                    self.addedMembers.value.remove(at: index)
                } else {
                    self.addedMembers.value.append(member)
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asDriver()
            .drive(onNext: { [weak self] (indexPath) in
                guard let `self` = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }

}

extension Reactive where Base: ScheduleAddParticipantsViewController {
    
    static func createScheduleAddParticipants(selectedMembers: [Member], parent: UIViewController) -> Observable<ScheduleAddParticipantsViewController> {
        return Observable.create { [weak parent] (observer) -> Disposable in
            let scheduleAddParticipantsViewController = R.storyboard.main.scheduleAddParticipantsViewController()!
            scheduleAddParticipantsViewController.selectedMembers = selectedMembers
            let nav = UINavigationController(rootViewController: scheduleAddParticipantsViewController)
            _ = scheduleAddParticipantsViewController.view
            let cancel = scheduleAddParticipantsViewController.cancelBarButtonItem.rx.tap.asObservable()
                .subscribe(onNext: {
                    observer.onCompleted()
                    scheduleAddParticipantsViewController.dismiss(animated: true, completion: nil)
                })
            parent?.present(nav, animated: true, completion: nil)
            observer.onNext(scheduleAddParticipantsViewController)
            
            
            let dismiss = Disposables.create {
                scheduleAddParticipantsViewController.dismiss(animated: true, completion: nil)
            }
            
            return Disposables.create([cancel, dismiss])
        }
    }
    
    var ensureAddMembers: Observable<[Member]> {
        _ = self.base.view
        return self.base.doneBarButtonItem.rx.tap.asObservable()
            .withLatestFrom(self.base.addedMembers.asObservable())
    }
    
}
