//
//  ViewController.swift
//  HFanMenu
//
//  Created by Developer on 6/16/19.
//  Copyright © 2019 WhatsThat. All rights reserved.
//

import UIKit


struct MenuItem {
	var title: String
	var image: String
}

class ViewController: UIViewController {

	var menuView: HMenuView!
	var isShow = false
	let menuItems: [MenuItem] = [MenuItem(title: "nguyen trung hieu", image: "ico-create-report"),
								 MenuItem(title: "trung", image: "ico-my-reports"),
								 MenuItem(title: "hieu", image: "ico-near-reports")]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let menuButton = HMainButton(
			image: UIImage(named:"ico-plus")!.withRenderingMode(.alwaysOriginal),
			selectedImage: UIImage(named: "ico-close"),
			size: CGSize(width: 50, height: 50))
		let animator = HAnimator(duration: 0.4, springWithDamping: 0.5, springVelocity: 0.5)
		
		
		menuView = HMenuView(parentView: view, mainButon: menuButton, animator: animator, isClockWise: true, radius: 110)
		menuView.delegate = self
		menuView.datasource = self
		menuView.setHomeButtonPosition(position: CGPoint(x: view.bounds.width - 50, y: view.center.y - 100))
	}
}



extension ViewController: HMenuDatasource {

	
	
	func numberOfItems() -> Int {
		return menuItems.count
	}



	func menuView(_ menuView: HMenuView, menuItemAtIndex index: Int) -> HMenuItem {
		let subMenuButton = HMenuItem(tagNumber: index, image: UIImage(named: menuItems[index].image)!, size: CGSize(width: 60, height: 60))
		subMenuButton.backgroundColor = .clear
		subMenuButton.layer.masksToBounds = true
		return subMenuButton
	}
	
	
	
	func menuView(_ menuView: HMenuView, menuLabelAtIndex index: Int) -> UILabel {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
		label.text = menuItems[index].title
		return label
	}
}

extension ViewController: HMenuDelegate {
	
	
	
	func menuView(_ menuView: HMenuView, didTapMenuItemAtIndex index: Int) {
		
	}
	
	
	
	
	func menuView(_ menuView: HMenuView, didTapMainButton: HMainButton, state: HMenuViewState) {
		
	}
}


