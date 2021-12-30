//
//  ViewController.swift
//  PicsumImageCollectionView
//
//  Created by JinGu's iMac on 2021/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MainViewController: UIViewController {

    let imageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var imageDic = [IndexPath:DataSet]()
    
    let numberOfImages : Int = 50
    
    let interactor = Interactor()

    var tempImageView : UIImageView?
    
    var viewModel : MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [imageCollectionView]
            .forEach{ self.view.addSubview($0) }
        
        setUI()
        binding()
    }
    
    func setUI(){
        
        self.title = "Lorem Picsum"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = UIColor.white
        
        imageCollectionView.snp.makeConstraints{ [weak self] in
            guard let self = self else { return }
            $0.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        imageCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        imageCollectionView.backgroundColor = UIColor.white
        imageCollectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
    }

    func binding(){
        
        viewModel.picsumImages
            .bind(to: imageCollectionView.rx.items) { collectionView, index, item in
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: IndexPath(row: index, section: 0)) as? CollectionViewCell else { return UICollectionViewCell() }
                
                cell.imageView.image = item.image.resizeImage(toSize: cell.imageView.frame.size)
                
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        Observable.zip(imageCollectionView.rx.itemSelected, imageCollectionView.rx.modelSelected(PicsumImage.self))
            .subscribe { [unowned self] (indexPath, item) in
                
                guard let att = imageCollectionView.layoutAttributesForItem(at: indexPath) else { return }
                let cellFrame = imageCollectionView.convert(att.frame, to: self.view)

                self.tempImageView = UIImageView(frame: cellFrame)
                self.tempImageView?.image = item.image
                self.tempImageView?.contentMode = .scaleAspectFit
                self.view.addSubview(self.tempImageView!)
                
                let imageVC = ImageViewController()
                imageVC.image = item.image
                imageVC.indexPath = indexPath
                imageVC.interactor = self.interactor
                let naviCon = UINavigationController(rootViewController: imageVC)
                naviCon.modalPresentationStyle = .overCurrentContext
                naviCon.transitioningDelegate = self
                self.present(naviCon, animated: true, completion: nil)
            }
            .disposed(by: rx.disposeBag)
    }

}

extension MainViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width / 2
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
    
}


extension MainViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DismissAnimator()
    }
    
//    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return interactor.hasStarted ? interactor : nil
//    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
