//
//  ViewController.swift
//  HFanMenu
//
//  Created by Developer on 6/16/19.
//  Copyright © 2019 WhatsThat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var menuView: HMenuView!
	var isShow = false
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let menuButton = HMainButton(image: UIImage(named:"menu")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "close"), size: CGSize(width: 50, height: 50))
		let animator = HAnimator(duration: 0.5, springWithDamping: 0.5, springVelocity: 0.5)
		menuView = HMenuView(parentView: view, mainButon: menuButton, animator: animator, isClockWise: true, radius: 130)
		menuView.delegate = self
		menuView.datasource = self
		menuView.setHomeButtonPosition(position: CGPoint(x: view.center.x, y: view.center.y - 100))
	}
}



extension ViewController: HMenuDatasource {

	
	
	func numberOfItems() -> Int {
		return 3
	}



	func menuView(_ menuView: HMenuView, menuItemAtIndex index: Int) -> HMenuItem {
		let subMenuButton = HMenuItem(tagNumber: index, image: UIImage(named:"\(index)")!, size: CGSize(width: 60, height: 60))
		subMenuButton.backgroundColor = UIColor.init(red: 243/255.0, green: 156/255.0, blue: 18/255.0, alpha: 1)
		subMenuButton.layer.cornerRadius = subMenuButton.frame.height / 2
		subMenuButton.layer.masksToBounds = true
		return subMenuButton
	}
}

extension ViewController: HMenuDelegate {
	
	
	
	func menuView(_ menuView: HMenuView, didTapMenuItemAtIndex index: Int) {
		
	}
	
	
	
	
	func menuView(_ menuView: HMenuView, didTapMainButton: HMainButton, state: HMenuViewState) {
		
	}
}


