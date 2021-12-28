//
//  PicsumImage.swift
//  PicsumImageCollectionView
//
//  Created by JinGu's iMac on 2021/12/28.
//

import Foundation
import UIKit
import Differentiator
import RxSwift

struct PicsumImage : IdentifiableType, Equatable {
    
    let identity : String
    let image : UIImage
    
    internal init(image: UIImage) {
        self.identity = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        self.image = image
    }
    
    static func ==(lhs: PicsumImage, rhs: PicsumImage) -> Bool {
        return lhs.identity == rhs.identity
    }
}
