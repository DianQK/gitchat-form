//
//  ScheduleNoteViewController.swift
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

class ScheduleNoteViewController: UIViewController {

    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension Reactive where Base: ScheduleNoteViewController {

    static func createScheduleNote(defaultText: String, previousViewController: UIViewController?) -> Observable<ScheduleNoteViewController> {
        return Observable.create({ [weak previousViewController] (observer) -> Disposable in
            let scheduleNoteViewController = R.storyboard.main.scheduleNoteViewController()!
            _ = scheduleNoteViewController.view
            scheduleNoteViewController.textView.text = defaultText
            previousViewController?.show(scheduleNoteViewController, sender: nil)
            observer.onNext(scheduleNoteViewController)
            return Disposables.create {
                if let nav = scheduleNoteViewController.navigationController, nav.topViewController == scheduleNoteViewController {
                    nav.popViewController(animated: true)
                }
            }
        })
    }

    var done: Observable<String> {
        return self.base.doneBarButtonItem.rx.tap.asObservable()
            .withLatestFrom(self.base.textView.rx.text.orEmpty)
    }

}
