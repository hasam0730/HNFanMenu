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

	var menuView: WTMenuHandler!
	var isShow = false
	let menuItems: [MenuItem] = [
		MenuItem(title: "hieu", image: "ico-create-report"),
		MenuItem(title: "hieu", image: "ico-my-reports"),
		MenuItem(title: "hieu", image: "ico-near-reports")
	]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let menuButton = WTMainButton(
			image: UIImage(named:"ico-plus")!.withRenderingMode(.alwaysOriginal),
			expandedImage: UIImage(named: "ico-close"),
			frame: CGRect(origin: view.center, size: CGSize(width: 60, height: 60)))
		
		let animator = HAnimator(
			duration: 0.4,
			springWithDamping: 0.6,
			springVelocity: 0.5)
		
		menuView = WTMenuHandler(
			parentView: view,
			mainButon: menuButton,
			animator: animator,
			isClockWise: true,
			radius: 110)
		
		menuView.delegate = self
		menuView.datasource = self
	}
}



extension ViewController: WTMenuDatasource {

	
	
	func numberOfSubButtons() -> Int {
		return menuItems.count
	}



	func fanMenu(_ menuHandler: WTMenuHandler, menuItemAtIndex index: Int) -> WTSubButton {
		let subMenuButton = WTSubButton(
			tagNumber: index,
			image: UIImage(named: menuItems[index].image)!,
			frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 60)))
		subMenuButton.backgroundColor = .clear
		subMenuButton.layer.masksToBounds = true
		return subMenuButton
	}
	
	
	
	func fanMenu(_ menuHandler: WTMenuHandler, menuLabelAtIndex index: Int) -> UILabel {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
		label.text = menuItems[index].title
		return label
	}
}

extension ViewController: WTMenuDelegate {
	
	
	
	func fanMenu(_ menuHandler: WTMenuHandler, didTapMenuItemAtIndex index: Int) {
		
	}
	
	
	
	
	func fanMenu(_ menuHandler: WTMenuHandler, didTapMainButton: WTMainButton, state: WTFanMenuState) {
		
	}
}


