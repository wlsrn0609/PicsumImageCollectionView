//
//  ImageAPI.swift
//  PicsumImageCollectionView
//
//  Created by JinGu's iMac on 2021/12/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ImageAPI {
    
    private let urlSession = URLSession.shared

    private let request : URLRequest = {
    
        let urlString = "https://picsum.photos/2560/1440/?random"
        
        let url = URL(string: urlString)!
        return URLRequest(url: url)
        
    }()
    
    func fetch() -> Observable<UIImage?> {
        return urlSession.rx.data(request: request)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map{ UIImage(data: $0) }
    }
}
