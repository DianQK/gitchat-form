//
//  ImageCollectionListViewController.swift
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

extension Array where Element: AnyObject {
    
    public init(_ fetchResult: PHFetchResult<Element>) {
        var array: [Element] = []
        for i in (0..<fetchResult.count) {
            array.append(fetchResult[i])
        }
        self = array
    }

}

extension PHAssetCollection {
    
    open class func fetchAssetCollections(with type: PHAssetCollectionType, subtype: PHAssetCollectionSubtype, options: PHFetchOptions?) -> Array<PHAssetCollection> {
        return Array<PHAssetCollection>(fetchAssetCollections(with: type, subtype: subtype, options: options))
    }
    
}

open class ImagePickerService {
    
    open class func fetchAssetCollections(fetchOptions: PHFetchOptions = PHFetchOptions()) -> [PHAssetCollection] {
        let cameraRollResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: fetchOptions) as [PHAssetCollection]
        let favoritesResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: fetchOptions) as [PHAssetCollection]
        let albumResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions) as [PHAssetCollection]
        return [cameraRollResult, favoritesResult, albumResult].flatMap { $0 }
    }
    
    open class func fetchAssets(in assetCollection: PHAssetCollection, options: PHFetchOptions = PHFetchOptions()) -> [PHAsset] {
        return Array<PHAsset>(PHAsset.fetchAssets(in: assetCollection, options: options))
    }
    
}

extension Reactive where Base: PHImageManager {
    
    public func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?) -> Observable<(UIImage, [AnyHashable: Any]?)> {
        
        return Observable.create({ [weak manager = self.base] (observer) -> Disposable in
            guard let manager = manager else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let requestID = manager
                .requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        observer.onNext((image, info))
                        if image.size == targetSize {
                            observer.onCompleted()
                        }
                    }
                    if (info?["PHImageFileURLKey"] != nil) {
                        observer.onCompleted()
                    }
                })
            
            return Disposables.create {
                manager.cancelImageRequest(requestID)
            }
            
        })
        
    }

    public func requestImageData(for asset: PHAsset, options: PHImageRequestOptions?) -> Observable<(Data, String?, UIImageOrientation, [AnyHashable : Any]?)> {
        
        return Observable.create({ [weak manager = self.base] (observer) -> Disposable in
            guard let manager = manager else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let requestID = manager
                .requestImageData(for: asset, options: options, resultHandler: { (data, string, imageOrientation, info) in
                    if let error = info?[PHImageErrorKey] as? NSError {
                        observer.onError(error)
                    } else if let data = data {
                        observer.onNext((data, string, imageOrientation, info))
                        observer.onCompleted()
                    }
                })
            
            return Disposables.create {
                manager.cancelImageRequest(requestID)
            }
            
        })
        
    }
    
}

class ImageCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
}

class ImageCollectionListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable
            .deferred {
                Observable.just(ImagePickerService.fetchAssetCollections())
            }
            .bind(to: tableView.rx.items(cellIdentifier: "ImageCollectionTableViewCell", cellType: ImageCollectionTableViewCell.self)) { row, element, cell in
                cell.collectionNameLabel.text = element.localizedTitle
                
//                cell.collectionImageView.image = element
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(PHAssetCollection.self).asDriver()
            .drive(onNext: { [weak self] (assetCollection) in
                guard let `self` = self else { return }
                self.performSegue(withIdentifier: "showSelectImages", sender: assetCollection)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asDriver()
            .drive(onNext: { [weak self] (indexPath) in
                guard let `self` = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            super.prepare(for: segue, sender: sender)
            return
        }
        switch (segue.destination, identifier, sender) {
        case let (viewController as SelectImagesViewController, "showSelectImages", assetCollection as PHAssetCollection):
            viewController.assetCollection = assetCollection
        default:
            break
        }
    }

}
