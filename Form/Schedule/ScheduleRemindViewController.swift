//
//  ScheduleRemindViewController.swift
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

enum CustomMessageError: Swift.Error, LocalizedError {
    case message(String)

    var errorDescription: String? {
        switch self {
        case let .message(message):
            return message
        }
    }
}

extension ObservableConvertibleType {

    func catchErrorShowMessageWithCompleted() -> Observable<E> {
        return self.asObservable().catchError({ (error) -> Observable<E> in
            NotificationBanner(title: "遇到了个错误", subtitle: error.localizedDescription, style: .warning).show()
            return Observable.empty()
        })
    }

}

extension Reactive where Base: UITableViewCell {

    public var accessoryType: UIBindingObserver<Base, UITableViewCellAccessoryType> {
        return UIBindingObserver(UIElement: self.base, binding: { (cell, accessoryType) in
            cell.accessoryType = accessoryType
        })
    }
    
}

typealias ScheduleRemindSection = SectionModel<(), Remind?>



class ScheduleRemindViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let dataSource = RxTableViewSectionedReloadDataSource<ScheduleRemindSection>()

    var currentStartDate: Date = Date()
    var remind: Variable<Remind?>!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.configureCell = { [weak self] dataSource, tableView, indexPath, element in
            guard let `self` = self else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.remindCell, for: indexPath)!
            cell.textLabel?.text = element?.title ?? "无"
            self.remind.asObservable()
                .map { $0 == element }
                .map { $0 ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none }
                .bind(to: cell.rx.accessoryType)
                .disposed(by: cell.reuseDisposeBag)

            return cell
        }

        Observable.just([
            Remind.start,
            Remind.beforeMins(5),
            Remind.beforeMins(15),
            Remind.beforeMins(30),
            Remind.beforeHours(1),
            Remind.beforeHours(2),
            Remind.beforeHours(3)
            ] as [Remind?])
            .map { [ScheduleRemindSection(model: (), items: [nil]), ScheduleRemindSection(model: (), items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Remind?.self)
            .withLatestFrom(remind.asObservable()) { selectedRemind, currentRemind in
                return (selectedRemind: selectedRemind, currentRemind: currentRemind)
            }
            .flatMap { [weak self] (selectedRemind, currentRemind) -> Observable<Remind?> in
                guard let `self` = self else { return Observable.empty() }
                return Observable<Remind?>.create({ (observer) -> Disposable in
                    
                    if selectedRemind == currentRemind {
                        observer.onCompleted()
                    } else if let selectedRemind = selectedRemind, selectedRemind.changedTime(for: self.currentStartDate) < Date() {
                        observer.onError(CustomMessageError.message("请设置提醒事件晚于当前时间"))
                    } else {
                        observer.onNext(selectedRemind)
                        observer.onCompleted()
                    }
                    return Disposables.create()
                })
                .catchErrorShowMessageWithCompleted()
            }
            .do(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .bind(to: self.remind)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected.asDriver()
            .drive(onNext: { [weak self] (indexPath) in
                guard let `self` = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)



    }

}
