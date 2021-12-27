//
//  DataSet.swift
//  PicsumImageCollectionView
//
//  Created by JinGu's iMac on 2021/12/24.
//

import Foundation
import RxSwift
import NSObject_Rx
import RxRelay

class DataSet {
    
    var disposeBag = DisposeBag()
    
    let image = BehaviorRelay<UIImage?>(value: nil)
    var disposable : Disposable?
    //생성과 동시에 이미지를 다운받고, image 객체는 업데이트된다. image를 구독하면 업데이트에 반응할 수 있다
    
    init() {
        
    }
    
    func fetch(){
        disposable = ImageAPI().fetch()
            .filter{ $0 != nil }
            .drive(image)
        
        disposable?
            .disposed(by: disposeBag)
    }
    
}
