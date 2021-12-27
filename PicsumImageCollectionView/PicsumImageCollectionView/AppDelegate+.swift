//
//  AppDelegate+.swift
//  PicsumImageCollectionView
//
//  Created by JinGu's iMac on 2021/12/27.
//

import Foundation
import UIKit

let appDel = (UIApplication.shared.delegate as! AppDelegate)

let statusBarHeight = appDel.window?.safeAreaInsets.top ?? UIApplication.shared.statusBarFrame.size.height

struct SCREEN {
    static var WIDTH : CGFloat = { UIScreen.main.bounds.size.width }()
    static var HEIGHT : CGFloat = { UIScreen.main.bounds.size.height }()
}
