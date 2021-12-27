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
    var cellFrame : CGRect = CGRect.zero
    
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
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureFunc(gesture:)))
        self.view.addGestureRecognizer(pan)
    }
    
    @objc func panGestureFunc(gesture : UIPanGestureRecognizer){
        let percentThreshold:CGFloat = 0.3
        let translation = gesture.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0)
        let downwardMovementPercent = fminf(downwardMovement,1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else {
            return
        }

        switch gesture.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        default:
            break
        }
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
}
