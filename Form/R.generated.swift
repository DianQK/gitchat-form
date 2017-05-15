//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 color palettes.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 0 files.
  struct file {
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 0 images.
  struct image {
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 0 nibs.
  struct nib {
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 13 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `ImageCollectionTableViewCell`.
    static let imageCollectionTableViewCell: Rswift.ReuseIdentifier<ImageCollectionTableViewCell> = Rswift.ReuseIdentifier(identifier: "ImageCollectionTableViewCell")
    /// Reuse identifier `ParticipantsCell`.
    static let participantsCell: Rswift.ReuseIdentifier<ReactiveTableViewCell> = Rswift.ReuseIdentifier(identifier: "ParticipantsCell")
    /// Reuse identifier `RemindCell`.
    static let remindCell: Rswift.ReuseIdentifier<ReactiveTableViewCell> = Rswift.ReuseIdentifier(identifier: "RemindCell")
    /// Reuse identifier `ScheduleBellTableViewCell`.
    static let scheduleBellTableViewCell: Rswift.ReuseIdentifier<ScheduleBellTableViewCell> = Rswift.ReuseIdentifier(identifier: "ScheduleBellTableViewCell")
    /// Reuse identifier `ScheduleNoteTableViewCell`.
    static let scheduleNoteTableViewCell: Rswift.ReuseIdentifier<ScheduleNoteTableViewCell> = Rswift.ReuseIdentifier(identifier: "ScheduleNoteTableViewCell")
    /// Reuse identifier `ScheduleParticipantItemCollectionViewCell`.
    static let scheduleParticipantItemCollectionViewCell: Rswift.ReuseIdentifier<ScheduleParticipantItemCollectionViewCell> = Rswift.ReuseIdentifier(identifier: "ScheduleParticipantItemCollectionViewCell")
    /// Reuse identifier `ScheduleParticipantTableViewCell`.
    static let scheduleParticipantTableViewCell: Rswift.ReuseIdentifier<ScheduleParticipantTableViewCell> = Rswift.ReuseIdentifier(identifier: "ScheduleParticipantTableViewCell")
    /// Reuse identifier `ScheduleRemindTableViewCell`.
    static let scheduleRemindTableViewCell: Rswift.ReuseIdentifier<ScheduleRemindTableViewCell> = Rswift.ReuseIdentifier(identifier: "ScheduleRemindTableViewCell")
    /// Reuse identifier `ScheduleTextInputTableViewCell`.
    static let scheduleTextInputTableViewCell: Rswift.ReuseIdentifier<ScheduleTextInputTableViewCell> = Rswift.ReuseIdentifier(identifier: "ScheduleTextInputTableViewCell")
    /// Reuse identifier `ScheduleTextTableViewCell`.
    static let scheduleTextTableViewCell: Rswift.ReuseIdentifier<ScheduleTextTableViewCell> = Rswift.ReuseIdentifier(identifier: "ScheduleTextTableViewCell")
    /// Reuse identifier `ScheduleTimePickerTableViewCell`.
    static let scheduleTimePickerTableViewCell: Rswift.ReuseIdentifier<ScheduleTimePickerTableViewCell> = Rswift.ReuseIdentifier(identifier: "ScheduleTimePickerTableViewCell")
    /// Reuse identifier `ScheduleTimeTableViewCell`.
    static let scheduleTimeTableViewCell: Rswift.ReuseIdentifier<ScheduleTimeTableViewCell> = Rswift.ReuseIdentifier(identifier: "ScheduleTimeTableViewCell")
    /// Reuse identifier `SelectImageCollectionViewCell`.
    static let selectImageCollectionViewCell: Rswift.ReuseIdentifier<SelectImageCollectionViewCell> = Rswift.ReuseIdentifier(identifier: "SelectImageCollectionViewCell")
    
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 3 view controllers.
  struct segue {
    /// This struct is generated for `ImageCollectionListViewController`, and contains static references to 1 segues.
    struct imageCollectionListViewController {
      /// Segue identifier `showSelectImages`.
      static let showSelectImages: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, ImageCollectionListViewController, SelectImagesViewController> = Rswift.StoryboardSegueIdentifier(identifier: "showSelectImages")
      
      /// Optionally returns a typed version of segue `showSelectImages`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showSelectImages(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, ImageCollectionListViewController, SelectImagesViewController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.imageCollectionListViewController.showSelectImages, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    /// This struct is generated for `NewScheduleViewController`, and contains static references to 1 segues.
    struct newScheduleViewController {
      /// Segue identifier `changeRemind`.
      static let changeRemind: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, NewScheduleViewController, ScheduleRemindViewController> = Rswift.StoryboardSegueIdentifier(identifier: "changeRemind")
      
      /// Optionally returns a typed version of segue `changeRemind`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func changeRemind(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, NewScheduleViewController, ScheduleRemindViewController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.newScheduleViewController.changeRemind, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    /// This struct is generated for `SelectImagesViewController`, and contains static references to 1 segues.
    struct selectImagesViewController {
      /// Segue identifier `showSelectImageDetail`.
      static let showSelectImageDetail: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, SelectImagesViewController, SelectImageDetailViewController> = Rswift.StoryboardSegueIdentifier(identifier: "showSelectImageDetail")
      
      /// Optionally returns a typed version of segue `showSelectImageDetail`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showSelectImageDetail(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, SelectImagesViewController, SelectImageDetailViewController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.selectImagesViewController.showSelectImageDetail, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try main.validate()
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let name = "Main"
      let scheduleAddParticipantsViewController = StoryboardViewControllerResource<ScheduleAddParticipantsViewController>(identifier: "ScheduleAddParticipantsViewController")
      let scheduleNoteViewController = StoryboardViewControllerResource<ScheduleNoteViewController>(identifier: "ScheduleNoteViewController")
      let scheduleRemindViewController = StoryboardViewControllerResource<ScheduleRemindViewController>(identifier: "ScheduleRemindViewController")
      
      func scheduleAddParticipantsViewController(_: Void = ()) -> ScheduleAddParticipantsViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: scheduleAddParticipantsViewController)
      }
      
      func scheduleNoteViewController(_: Void = ()) -> ScheduleNoteViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: scheduleNoteViewController)
      }
      
      func scheduleRemindViewController(_: Void = ()) -> ScheduleRemindViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: scheduleRemindViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.main().scheduleAddParticipantsViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'scheduleAddParticipantsViewController' could not be loaded from storyboard 'Main' as 'ScheduleAddParticipantsViewController'.") }
        if _R.storyboard.main().scheduleRemindViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'scheduleRemindViewController' could not be loaded from storyboard 'Main' as 'ScheduleRemindViewController'.") }
        if _R.storyboard.main().scheduleNoteViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'scheduleNoteViewController' could not be loaded from storyboard 'Main' as 'ScheduleNoteViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}