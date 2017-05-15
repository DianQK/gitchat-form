//
//  SelectImagesViewController.swift
//  Form
//
//  Created by wc on 2017/5/6.
//  Copyright © 2017年 t. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Photos

extension Reactive where Base: UIViewController {
    
    func performSegue<Sender>(withIdentifier identifier: String) -> UIBindingObserver<Base, Sender?> {
        return UIBindingObserver(UIElement: self.base, binding: { (viewController, sender) in
            viewController.performSegue(withIdentifier: identifier, sender: sender)
        })
    }
    
}

class SelectImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var selectButton: SelectButton!
    
    private(set) var reuseDisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reuseDisposeBag = DisposeBag()
    }
    
}

class SelectImagesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var assetCollection: PHAssetCollection!
    
    typealias SelectImagesItemModel = (asset: PHAsset, isSelected: Variable<Bool>)
    
    typealias SelectImagesSectionModel = SectionModel<(), SelectImagesItemModel>
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SelectImagesSectionModel>()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = assetCollection.localizedTitle
        
        dataSource.configureCell = { dataSource, collectionView, indexPath, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCollectionViewCell", for: indexPath) as! SelectImageCollectionViewCell
            let imageRequestOptions = PHImageRequestOptions()
            PHImageManager.default().rx
                .requestImage(for: element.asset, targetSize: CGSize(width: 80, height: 80), contentMode: PHImageContentMode.aspectFit, options: imageRequestOptions)
                .map { $0.0 }
                .bind(to: cell.selectImageView.rx.image)
                .disposed(by: cell.reuseDisposeBag)
            element.isSelected.asDriver()
                .drive(cell.selectButton.rx.isSelected)
                .disposed(by: cell.reuseDisposeBag)
            cell.selectButton.rx.tap.asDriver()
                .drive(onNext: {
                    element.isSelected.value = !element.isSelected.value
                })
                .disposed(by: cell.reuseDisposeBag)
            return cell
        }

        Observable
            .deferred { [weak self] () -> Observable<[PHAsset]> in
                guard let `self` = self else { return Observable.empty() }
                return Observable.just(ImagePickerService.fetchAssets(in: self.assetCollection))
            }
            .map { $0.map { SelectImagesItemModel(asset: $0, isSelected: Variable<Bool>(false)) } }
            .map { [SelectImagesSectionModel(model: (), items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
            
        collectionView.rx.modelSelected(SelectImagesItemModel.self).asDriver()
            .drive(self.rx.performSegue(withIdentifier: "showSelectImageDetail"))
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            super.prepare(for: segue, sender: sender)
            return
        }
        switch (segue.destination, identifier, sender) {
        case let (viewController as SelectImageDetailViewController, "showSelectImageDetail", selectImagesItem as SelectImagesItemModel):
            viewController.asset = selectImagesItem.asset
            viewController.imageIsSelected = selectImagesItem.isSelected
        default:
            break
        }
    }

}
