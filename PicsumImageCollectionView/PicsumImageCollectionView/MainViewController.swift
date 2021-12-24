//
//  ViewController.swift
//  PicsumImageCollectionView
//
//  Created by JinGu's iMac on 2021/12/24.
//

import UIKit
import SnapKit
import RxSwift
import NSObject_Rx

class MainViewController: UIViewController {

    let imageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var imageDic = [IndexPath:DataSet]()
    
    let numberOfImages : Int = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [imageCollectionView]
            .forEach{ self.view.addSubview($0) }
        
        setUI()
    }
    
    func setUI(){
        
        self.title = "TITLE"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = UIColor.white
        
        imageCollectionView.snp.makeConstraints{ [weak self] in
            guard let self = self else { return }
            $0.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        print("imageCollectionView.contentInset:\(imageCollectionView.contentInset)")
        imageCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }


}

extension MainViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.size.width / 2
        let height = width * (1440/2560)

        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfImages
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageView.image = nil
        
        let dataSet = imageDic[indexPath] ?? DataSet()
        imageDic[indexPath] = dataSet
        
        dataSet.image
            .map{ $0?.resizeImage(toSize: cell.imageView.frame.size) }
            .bind(to: cell.imageView.rx.image)
            .disposed(by: rx.disposeBag)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}

