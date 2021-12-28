//
//  ImageViewController.swift
//  PicsumImageCollectionView
//
//  Created by JinGu's iMac on 2021/12/24.
//

import Foundation
import UIKit

class ImageViewController : UIViewController {
    
    var interactor : Interactor? = nil

    let imageView = UIImageView()
    var image : UIImage?
    
    var indexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(imageView)
        
        setUI()
    }
    
    func setUI(){
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.close))
        
        let naviBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 50
        let imageViewY = naviBarHeight + statusBarHeight
        let bottomSafeAreaHeight = appDel.window?.safeAreaInsets.bottom ?? 0
        let imageViewHeight = SCREEN.HEIGHT - imageViewY - bottomSafeAreaHeight
        imageView.frame = CGRect(x: 0, y: imageViewY, width: SCREEN.WIDTH, height: imageViewHeight)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        if let image = image {
            imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width * (image.size.height / image.size.width))
            imageView.center = self.view.center
//            imageView.center.y = (imageViewY + imageViewHeight) / 2
        }
        
        imageVieworiginRect = imageView.frame
        imageViewOriginCenter = imageView.center
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureFunc(gesture:)))
        self.view.addGestureRecognizer(pan)
    }
    
    var imageVieworiginRect : CGRect = CGRect.zero
    var imageViewOriginCenter : CGPoint = CGPoint.zero
    @objc func panGestureFunc(gesture : UIPanGestureRecognizer){
        
        let move = gesture.translation(in: view)
        let moveY = move.y
        let moveX = move.x
        let moveY_ratio = abs(moveY / SCREEN.HEIGHT)
        let moveX_ratio = abs(moveX / SCREEN.WIDTH)
//        print("moveY_ratio:\(moveY_ratio)")
        let maxmumRatio = moveY_ratio
//        print("maxmumRatio:\(maxmumRatio)")
        
        switch gesture.state {
//        case .began:
        case .changed:
            
            let afterFrame = CGRect(
                x: imageVieworiginRect.origin.x + moveX,
                y: imageVieworiginRect.origin.y + moveY,
                width: imageVieworiginRect.size.width * (1 - maxmumRatio),
                height: imageVieworiginRect.size.height * (1 - maxmumRatio))
            imageView.frame = afterFrame
            
            var alpha = maxmumRatio * 5
            alpha = (1 - alpha)
            alpha = min(1, alpha)
            alpha = max(0, alpha)
            self.view.backgroundColor = UIColor.white.withAlphaComponent(alpha)
            self.navigationController?.navigationBar.alpha = alpha
        case .cancelled,.ended:
            
            if maxmumRatio > 0.15 {
                self.dismiss(animated: true, completion: nil)
            }else{
                UIView.animate(withDuration: 0.3) {
                    self.imageView.frame = self.imageVieworiginRect
                    self.view.backgroundColor = UIColor.white
                    self.navigationController?.navigationBar.alpha = 1
                } completion: { _ in }
            }
            
        default:
            break
        }

        return
        
    }
    
    @objc func close(){
        print("close")
        self.dismiss(animated: true , completion: nil)
    }
    
    @objc func save(){
        guard let image = imageView.image else { return }
        
        let alertCon = UIAlertController(title: "이미지 저장", message: "이미지를 저장하시겠습니까?", preferredStyle: .alert)
        alertCon.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alertCon.addAction(UIAlertAction(title: "저장", style: .default, handler: { _ in
            #if targetEnvironment(macCatalyst)
            
            #else
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            #endif
        }))
        self.present(alertCon, animated: true , completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error{
            print("save image fail \(error.localizedDescription)")
            let alertCon = UIAlertController(title: "저장 실패", message: "\(error.localizedDescription)", preferredStyle: .alert)
            alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alertCon, animated: true, completion: nil)
        }else{
            let alertCon = UIAlertController(title: "저장 완료", message: "이미지가 저장되었습니다.", preferredStyle: .alert)
            alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alertCon, animated: true, completion: nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(#function + ":\(size)")
        
        
        UIView.animate(withDuration: coordinator.transitionDuration) { [weak self] in
            guard let self = self,
                  let image = self.image else { return }
            self.imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height * (image.size.width / image.size.height))
            self.imageView.center = CGPoint(x: size.width / 2, y: size.height / 2)
        } completion: { _ in
        
        }

        
        
        
        
        
        /*
         top:Optional(50.0)
         bottom:Optional(34.0)
         height:50.0
         */
//        let naviBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 50
//        let imageViewY = naviBarHeight + statusBarHeight
//        let bottomSafeAreaHeight = appDel.window?.safeAreaInsets.bottom ?? 0
//        let imageViewHeight = SCREEN.HEIGHT - imageViewY - bottomSafeAreaHeight
//
//        if let image = image {
//            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height * (image.size.height / image.size.width))
//            imageView.center.y = (imageViewY + imageViewHeight) / 2
//        }
    }
    
    
    func showHelperCircle(){
        let center = CGPoint(x: view.bounds.width * 0.5, y: 100)
        let small = CGSize(width: 30, height: 30)
        let circle = UIView(frame: CGRect(origin: center, size: small))
        circle.layer.cornerRadius = circle.frame.width / 2
        circle.backgroundColor = UIColor.white
        circle.layer.shadowOpacity = 0.8
        circle.layer.shadowOffset = CGSize.zero
        self.view.addSubview(circle)
        UIView.animate(withDuration: 0.5, delay: 0.25) {
            circle.frame.origin.y += 200
            circle.layer.opacity = 0
        } completion: { _ in
            circle.removeFromSuperview()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showHelperCircle()
    }
}
