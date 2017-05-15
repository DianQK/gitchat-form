//
//  ReactiveTableViewCell.swift
//  Form
//
//  Created by DianQK on 14/05/2017.
//  Copyright © 2017 t. All rights reserved.
//

import UIKit
import RxSwift

open class ReactiveTableViewCell: UITableViewCell {

    public private(set) var reuseDisposeBag = DisposeBag()

    open override func prepareForReuse() {
        super.prepareForReuse()
        reuseDisposeBag = DisposeBag()
    }
    
}
