//
//  MainViewModel.swift
//  PicsumImageCollectionView
//
//  Created by JinGu's iMac on 2021/12/28.
//

import Foundation
import Differentiator
import RxDataSources
import RxSwift
import RxCocoa

typealias SectionModel = AnimatableSectionModel<Int, PicsumImage>

class MainViewModel {
    
    let dataSource : RxCollectionViewSectionedAnimatedDataSource<SectionModel> = {
        let ds = RxCollectionViewSectionedAnimatedDataSource<SectionModel> { (dataSource,collectionView,indexPath,item) in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
            
            cell.imageView.image = item.image
            
            return cell
        }
        
        return ds
    }()
    
    let picsumImages : Observable<[PicsumImage]> = {
        let disposeBag = DisposeBag()
        return Observable.create { observer in
            var images = [PicsumImage]()
            (0..<50).forEach { _ in
                ImageAPI().fetch()
                    .filter{ $0 != nil}
                    .subscribe(onNext: {
                        images.append(PicsumImage(image: $0!))
                        observer.onNext(images)
                        
                        if images.count == 50 { observer.onCompleted() }
                    })
                    .disposed(by: disposeBag)
            }
            
            return Disposables.create()
        }
    }()
    
}
