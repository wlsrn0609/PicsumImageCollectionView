//
//  ImageViewController.swift
//  PicsumImageCollectionView
//
//  Created by JinGu's iMac on 2021/12/24.
//

import Foundation
import UIKit

class ImageViewController : UIViewController {
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(imageView)
        
        setUI()
    }
    
    func setUI(){
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.close))
        
        imageView.snp.makeConstraints{ [weak self] in
            guard let self = self else { return }
            $0.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        imageView.contentMode = .scaleAspectFit
    }
    
    @objc func close(){
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
