//
//  NewScheduleViewController.swift
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

enum Remind: Equatable {
    case start
    case beforeMins(Int)
    case beforeHours(Int)

    var title: String {
        switch self {
        case .start:
            return "事件开始时"
        case let .beforeMins(mins):
            return "提前\(mins)分钟"
        case let .beforeHours(hours):
            return "提前\(hours)小时"
        }
    }

    func changedTime(for time: Date) -> Date {
        switch self {
        case .start:
            return time
        case let .beforeMins(mins):
            return time - mins.minutes
        case let .beforeHours(hours):
            return time - hours.hours
        }
    }

    static func ==(lhs: Remind, rhs: Remind) -> Bool {
        switch (lhs, rhs) {
        case (.start, .start):
            return true
        case (let .beforeMins(lMins), let .beforeMins(rMins)):
            return lMins == rMins
        case (let .beforeHours(lHours), let .beforeHours(rHours)):
            return lHours == rHours
        default:
            return false
        }
    }
}

struct Member: Equatable {
    let id: Int64
    let name: String
    let avatar: UIImage

    static var me: Member {
        return Member(id: 1, name: "Me", avatar: UIImage())
    }

    static func ==(lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.avatar == rhs.avatar
    }
}

class ScheduleForm {
    let name: Variable<String>
    let startTime: Variable<Date>
    let endTime: Variable<Date>
    let location: Variable<String>
    let participants: Variable<[Member]>
    let remind: Variable<Remind?>
    let isBellEnabled: Variable<Bool>
    let note: Variable<String>

    var isCompleted: Observable<Bool> {
        return self.name.asObservable().map { !$0.isEmpty }
    }

    var result: Observable<String> {
        return Observable.combineLatest(name.asObservable(), startTime.asObservable(), endTime.asObservable(), location.asObservable(), participants.asObservable(), remind.asObservable(), isBellEnabled.asObservable(), note.asObservable()) {
            var content = ""
            content += "日程主题：\($0)\n"
            content += "开始时间：\($1)\n"
            content += "结束时间：\($2)\n"
            content += "位置：\($3)\n"
            content += "参与人员：\($4.map { $0.name }.join(","))\n"
            content += "提醒：\($5?.title ?? "无")\n"
            content += "开启响铃：\($6)\n"
            content += "备注：\($7)"
            return content
        }
    }

    init(name: String, startTime: Date, endTime: Date, location: String, participants: [Member], remind: Remind?, isBellEnabled: Bool, note: String) {
        self.name = Variable(name)
        self.startTime = Variable(startTime)
        self.endTime = Variable(endTime)
        self.location = Variable(location)
        self.participants = Variable(participants)
        self.remind = Variable(remind)
        self.isBellEnabled = Variable(isBellEnabled)
        self.note = Variable(note)
    }

    static var `default`: ScheduleForm {
        return ScheduleForm(name: "", startTime: Date() + 1.hour, endTime: Date() + 2.hour, location: "", participants: [Member.me], remind: Remind.beforeMins(15), isBellEnabled: false, note: "")
    }

    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年M月d日\nh:mm"
        return formatter
    }()
}

enum NewScheduleItem: Equatable, IdentifiableType {

    case name(Variable<String>)
    case time(start: Variable<Date>, end: Variable<Date>)
    case selectTime(Variable<Date>)
    case location(Variable<String>)
    case participants([Member])
    case addRemind
    case remind(Variable<Remind?>)
    case bell(isBellEnabled: Variable<Bool>)
    case note(String)

    var identity: String {
        switch self {
        case .name:
            return "name"
        case .selectTime:
            return "selectTime"
        case .time:
            return "time"
        case .location:
            return "location"
        case .participants:
            return "participants"
        case .addRemind:
            return "addRemind"
        case .remind:
            return "remind"
        case .bell:
            return "bell"
        case .note:
            return "note"
        }
    }

    static func ==(lhs: NewScheduleItem, rhs: NewScheduleItem) -> Bool {
        switch (lhs, rhs) {
        case (.name, .name):
            return true
        case (.time, .time):
            return true
        case (let .selectTime(lTime), let .selectTime(rTime)):
            return lTime === rTime
        case (.location, .location):
            return true
        case (let .participants(lMembers), let .participants(rMembers)):
            return lMembers == rMembers
        case (.addRemind, .addRemind):
            return true
        case (.bell, .bell):
            return true
        case (let .note(lNote), let .note(rNote)):
            return lNote == rNote
        default:
            return false
        }
    }

}

typealias NewScheduleSection = AnimatableSectionModel<String, NewScheduleItem>

infix operator <-> : DefaultPrecedence

class NewScheduleViewController: UIViewController {

    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    let dataSource = RxTableViewSectionedAnimatedDataSource<NewScheduleSection>()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)

        let scheduleForm = ScheduleForm.default

        doneBarButtonItem.rx.tap.asObservable()
            .withLatestFrom(scheduleForm.result)
            .subscribe(onNext: { [weak self] content in
                let alert = UIAlertController(title: "", message: content, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        scheduleForm.result
            .debug()
            .subscribe()
            .disposed(by: disposeBag)

        scheduleForm.isBellEnabled.asObservable()
            .debug()
            .subscribe()
            .disposed(by: disposeBag)

        scheduleForm.isCompleted.bind(to: doneBarButtonItem.rx.isEnabled).disposed(by: disposeBag)

        let selectingTime = Variable<Variable<Date>?>(nil)
        let isNeedRemind = Variable(false)

        dataSource.configureCell = { dataSource, tableView, indexPath, element in
            switch element {
            case let .name(name):
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.scheduleTextInputTableViewCell, for: indexPath)!
                cell.textField.placeholder = "请输入日程主题"
                (cell.textField.rx.textInput <-> name).disposed(by: cell.reuseDisposeBag)
                return cell
            case let .time(start, end):
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.scheduleTimeTableViewCell, for: indexPath)!

                Observable
                    .combineLatest(start.asObservable(), end.asObservable(), selectingTime.asObservable()) { (start: $0, end: $1, selectingTime: $2) }
                    .subscribe(onNext: { selectedTime in

                        var startTitle = ScheduleForm.timeFormatter.string(from: selectedTime.start).attributedString
                        var endTitle = ScheduleForm.timeFormatter.string(from: selectedTime.end).attributedString

                        if selectedTime.start < Date() {
                            startTitle = startTitle.withStrikethroughStyle(UnderlineStyle.styleThick)
                                .withStrikethroughColor(Color.black)
                                .withBaselineOffset(0)
                        }

                        if selectedTime.end <= selectedTime.start || selectedTime.end <= Date() {
                            endTitle = endTitle.withStrikethroughStyle(UnderlineStyle.styleThick)
                                .withStrikethroughColor(Color.black)
                                .withBaselineOffset(0)
                        }

                        cell.startTimeButton.setAttributedTitle(startTitle, for: .normal)
                        cell.startTimeButton.setAttributedTitle(startTitle.withStrikethroughColor(Color.blue).withTextColor(Color.blue), for: .selected)

                        cell.endTimeButton.setAttributedTitle(endTitle, for: .normal)
                        cell.endTimeButton.setAttributedTitle(endTitle
                            .withStrikethroughColor(Color.blue)
                            .withTextColor(Color.blue), for: .selected)


                    })
                    .disposed(by: cell.reuseDisposeBag)

                selectingTime.asObservable()
                    .map { (selectingTime) -> Bool in
                        guard let selectingTime = selectingTime else { return false }
                        return selectingTime === start
                    }
                    .bind(to: cell.startTimeButton.rx.isSelected)
                    .disposed(by: cell.reuseDisposeBag)

                selectingTime.asObservable()
                    .map { (selectingTime) -> Bool in
                        guard let selectingTime = selectingTime else { return false }
                        return selectingTime === end
                    }
                    .bind(to: cell.endTimeButton.rx.isSelected)
                    .disposed(by: cell.reuseDisposeBag)

                cell.startTimeButton.rx.tap.asObservable()
                    .withLatestFrom(selectingTime.asObservable())
                    .map { (selectingTime) -> Variable<Date>? in
                        if let selectingTime = selectingTime, selectingTime === start {
                            return nil
                        } else {
                            return start
                        }
                    }
                    .bind(to: selectingTime)
                    .disposed(by: cell.reuseDisposeBag)

                cell.endTimeButton.rx.tap.asObservable()
                    .withLatestFrom(selectingTime.asObservable())
                    .map { (selectingTime) -> Variable<Date>? in
                        if let selectingTime = selectingTime, selectingTime === end {
                            return nil
                        } else {
                            return end
                        }
                    }
                    .bind(to: selectingTime)
                    .disposed(by: cell.reuseDisposeBag)

                return cell
            case let .selectTime(time):
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.scheduleTimePickerTableViewCell, for: indexPath)!
                (cell.datePicker.rx.date <-> time).disposed(by: cell.reuseDisposeBag)
                return cell
            case let .location(location):
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.scheduleTextInputTableViewCell, for: indexPath)!
                cell.textField.placeholder = "地点"
                (cell.textField.rx.textInput <-> location).disposed(by: cell.reuseDisposeBag)
                return cell
            case let .participants(members):
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.scheduleParticipantTableViewCell, for: indexPath)!
                return cell
            case .addRemind:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.scheduleTextTableViewCell, for: indexPath)!
                cell.titleLabel.attributedText = "填写备注、提醒".withTextColor(.lightGray)
                return cell
            case let .remind(remind):
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.scheduleRemindTableViewCell, for: indexPath)!
                remind.asObservable().map { $0?.title ?? "无" }
                    .bind(to: cell.remindBeforeLabel.rx.text)
                    .disposed(by: cell.reuseDisposeBag)
                return cell
            case let .bell(isBellEnabled):
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.scheduleBellTableViewCell, for: indexPath)!
                (cell.bellSwitch.rx.isOn <-> isBellEnabled).disposed(by: cell.reuseDisposeBag)
                return cell
            case let .note(note):
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.scheduleNoteTableViewCell, for: indexPath)!
                cell.noteTextLabel.attributedText = note.isEmpty ? "添加备注".withTextColor(.lightGray) : note.withTextColor(.black)
                return cell
            }
        }

        Observable
            .combineLatest(scheduleForm.participants.asObservable(), selectingTime.asObservable(), isNeedRemind.asObservable(), scheduleForm.note.asObservable()) { (participants: [Member], selectingTime: Variable<Date>?, isNeedRemind: Bool, note: String) -> [NewScheduleSection] in

            var baseSection = NewScheduleSection(model: "baseSection", items: [
                NewScheduleItem.name(scheduleForm.name),
                NewScheduleItem.time(start: scheduleForm.startTime, end: scheduleForm.endTime)
                ])

                if let selectingTime = selectingTime {
                    baseSection.items.append(NewScheduleItem.selectTime(selectingTime))
                }

                baseSection.items.append(NewScheduleItem.location(scheduleForm.location))

            let participantsSection = NewScheduleSection(model: "participantsSection", items: [
                NewScheduleItem.participants(participants)
                ])

            var remindSection = NewScheduleSection(model: "remindSection", items: [])
            if isNeedRemind {
                remindSection.items.append(contentsOf: [
                    NewScheduleItem.remind(scheduleForm.remind),
                    NewScheduleItem.bell(isBellEnabled: scheduleForm.isBellEnabled)
                    ])
            } else {
                remindSection.items.append(NewScheduleItem.addRemind)
            }

            var noteSection = NewScheduleSection(model: "noteSection", items: [])
                if isNeedRemind {
                    noteSection.items.append(NewScheduleItem.note(note))
                }

            return [baseSection, participantsSection, remindSection, noteSection]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        tableView.rx.itemSelected.asDriver()
            .drive(onNext: { [weak self] (indexPath) in
                guard let `self` = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(NewScheduleItem.self)
            .flatMap { (newScheduleItem) -> Observable<Bool> in
                switch newScheduleItem {
                case .addRemind:
                    return Observable.just(true)
                default:
                    return Observable.empty()
                }
            }
            .bind(to: isNeedRemind)
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(NewScheduleItem.self)
            .withLatestFrom(scheduleForm.startTime.asObservable()) { (newScheduleItem: $0, startTime: $1) }
            .flatMap { (newScheduleItem, startTime) -> Observable<(selectedRemind: Variable<Remind?>, currentStartTime: Date)> in
                switch newScheduleItem {
                case let .remind(selectedRemind):
                    return Observable.just((selectedRemind: selectedRemind, currentStartTime: startTime))
                default:
                    return Observable.empty()
                }
            }
            .bind(to: self.rx.performSegue(withIdentifier: "changeRemind"))
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(NewScheduleItem.self)
            .flatMap { (newScheduleItem) -> Observable<String> in
                switch newScheduleItem {
                case let .note(note):
                    return Observable.just(note)
                default:
                    return Observable.empty()
                }
            }
            .flatMap { [weak self] (defaultText) -> Observable<String> in
                return ScheduleNoteViewController.rx.createScheduleNote(defaultText: defaultText, previousViewController: self)
                    .flatMap { $0.rx.done }
                    .take(1)
            }
            .bind(to: scheduleForm.note)
            .disposed(by: disposeBag)


    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            super.prepare(for: segue, sender: sender)
            return
        }
        switch (segue.destination, identifier, sender) {
        case let (viewController as ScheduleRemindViewController, "changeRemind", (sender) as (selectedRemind: Variable<Remind?>, currentStartTime: Date)):
            viewController.currentStartDate = sender.currentStartTime
            viewController.remind = sender.selectedRemind
        default:
            break
        }
    }

}


extension NewScheduleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath] {
        case .name:
            return ScheduleTextTableViewCell.height
        case .time:
            return ScheduleTimeTableViewCell.height
        case .selectTime:
            return ScheduleTimePickerTableViewCell.height
        case .location:
            return ScheduleTextTableViewCell.height
        case let .participants(members):
            return ScheduleParticipantTableViewCell.height(memberCount: members.count)
        case .addRemind:
            return ScheduleTextTableViewCell.height
        case .remind:
            return ScheduleRemindTableViewCell.height
        case .bell:
            return ScheduleBellTableViewCell.height
        case let .note(note):
            return ScheduleNoteTableViewCell.height(note: note)
        }
    }

}
