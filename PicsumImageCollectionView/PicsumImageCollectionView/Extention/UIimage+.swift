//
//  UIimage+.swift
//  PicsumImageCollectionView
//
//  Created by JinGu's iMac on 2021/12/24.
//

import Foundation
import UIKit

extension UIImage {
    
    func resizeImage(toSize:CGSize) -> UIImage {
        
        let maxContentSize = max(self.size.width, self.size.height)
        let minimumToSize = min(toSize.width, toSize.height)
        let scale = (minimumToSize / maxContentSize) * UIScreen.main.scale
        
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let targetSize = self.size.applying(transform)
        
        UIGraphicsBeginImageContext(targetSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: targetSize))
        let afterImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return afterImage ?? self
    }
}
