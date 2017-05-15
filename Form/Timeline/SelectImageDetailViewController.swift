
//
//  SelectImageDetailViewController.swift
//  Form
//
//  Created by wc on 2017/5/7.
//  Copyright © 2017年 t. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxCocoa

extension CGSize {
    
    public static var greatestFiniteMagnitude: CGSize {
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    }
    
}

infix operator <->

public func <->(selectButton: SelectButton, isSelected: Variable<Bool>) -> Disposable {
    let isSelectedDisposable = isSelected.asDriver().drive(selectButton.rx.isSelected)
    let tapDisposable = selectButton.rx.tap.asDriver()
        .drive(onNext: {
            isSelected.value = !isSelected.value
        })
    return Disposables.create([isSelectedDisposable, tapDisposable])
    
}

class SelectImageDetailViewController: UIViewController {
    
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var selectButton: SelectButton!

    var asset: PHAsset!
    var imageIsSelected: Variable<Bool>!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageRequestOptions = PHImageRequestOptions()
        
        PHImageManager.default().rx.requestImage(for: asset, targetSize: CGSize.greatestFiniteMagnitude, contentMode: PHImageContentMode.aspectFill, options: imageRequestOptions)
            .map { $0.0 }
            .bind(to: displayImageView.rx.image)
            .disposed(by: disposeBag)
        
        (selectButton <-> imageIsSelected).disposed(by: disposeBag)
        
    }

}
