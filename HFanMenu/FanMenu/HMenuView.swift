//
//  HMenuView.swift
//  HFanMenu
//
//  Created by Developer on 6/16/19.
//  Copyright © 2019 WhatsThat. All rights reserved.
//

import UIKit



public protocol HMenuDelegate: class {
	
	func menuView(_ menuView: HMenuView, didTapMainButton: HMainButton, state: HMenuViewState)
	func menuView(_ menuView: HMenuView, didTapMenuItemAtIndex index: Int)
}



public protocol HMenuDatasource: class {
	
	func numberOfItems() -> Int
	func menuView(_ menuView: HMenuView, menuItemAtIndex index: Int) -> HMenuItem
}



public class HMenuView {
	
	private var parentView: UIView?
	private var mainButton: HMainButton?
	private var menuItems: [HMenuItem]? = []
	private var animator: HAnimator?
	
	var datasource: HMenuDatasource?
	var delegate: HMenuDelegate?
	public var isClockWise = true // Default is clockwise
	public var radius: Double = 100 // Default radius
	
	
	
	private(set) var state: HMenuViewState = .none {
		didSet {
			guard let menuItems = menuItems,
				let mainButton = mainButton else { return }
			state == .expand
			? animator?.showItems(items: menuItems, completion: nil)
			: animator?.hideItems(items: menuItems, completion: nil)
			animator?.animateMainButton(button: mainButton, state: state, completion: nil)
			mainButton.markButtonAsSelected(isSelected: state == .expand)
		}
	}
	
	
	
	init(parentView: UIView,
		 mainButon: HMainButton?,
		 animator: HAnimator,
		 isClockWise: Bool,
		 radius: Double) {
		self.parentView = parentView
		self.mainButton = mainButon
		self.animator = animator
		self.isClockWise = isClockWise
		self.radius = radius
		setup()
	}
	
	
	
	convenience public init(
		parentView: UIView,
		mainButton: HMainButton,
		radius: Double = 100,
		isClockWise: Bool = true) {
		self.init(
			parentView: parentView,
			mainButon: mainButton,
			animator: HAnimator(),
			isClockWise: true,
			radius: radius)
	}
	
	
	
	private func setup() {
		setUpHomeButton()
	}
	
	
	
	fileprivate func setUpHomeButton() {
		guard let parentView = parentView else {
			return
		}
		setUpDefaultHomeButtonPosition()
		mainButton?.delegate = self
		mainButton?.backgroundColor = .green
		mainButton?.frame.size = CGSize(width: 50, height: 50)
		parentView.addSubview(mainButton!)
		parentView.bringSubviewToFront(mainButton!)
	}
	
	
	
	fileprivate func setUpDefaultHomeButtonPosition() {
		guard let parentView = parentView else {
			return
		}
		mainButton?.center = parentView.center
	}
	
	
	
	public func reloadButton() {
		state = .none
		removeButton()
		addButton()
		layoutButton()
	}
	
	
	
	private func addButton() {
		guard let numberOfItem = datasource?.numberOfItems() else { return }
		for i in 0..<numberOfItem {
			let button = datasource!.menuView(self, menuItemAtIndex: i)
			button.delegate = self
			parentView?.addSubview(button)
			parentView?.bringSubviewToFront(button)
			menuItems?.append(button)
			
		}
	}
	
	
	
	private func removeButton() {
		let _ =  menuItems?.map { $0.removeFromSuperview() }
		menuItems?.removeAll()
	}
	
	
	
	private func layoutButton() {
		let theta = getTheta()
		let flip: Double = isClockWise ? 1 : -1
		var index = 0
		let center = CGPoint(x: mainButton!.frame.midX, y: mainButton!.frame.midY)
		menuItems?.forEach { (item) in
			var x = 0.0
			var y = 0.0
			x = Double(center.x) + sin(Double(index) * theta) * radius * flip
			y = Double(center.y) - cos(Double(index) * theta) * radius
			
			item.center = center
			item.startPosition = center
			item.endPosition = CGPoint(x: x, y: y)
			
			let label = UILabel(frame: CGRect(origin: item.l!, size: CGSize(width: 100, height: 30)))
			label.text = "asdadad"
			parentView?.addSubview(label)llllllllllllllllllllllllll
			
			item.tag = index
			item.alpha = 0
			index += 1
		}
		
	}
	
	
	
	private func getTheta() -> Double {
		let numberItem: Double = Double(datasource!.numberOfItems() == 0 ? 1 : datasource!.numberOfItems() - 1)
		return .pi / 2 / numberItem
	}
	
	
	
	private func setHomeButtonImage(pressed: Bool) {
		mainButton?.markButtonAsSelected(isSelected: pressed)
	}
	
	
	
	public func setHomeButtonPosition(position: CGPoint) {
		mainButton?.center = position
		reloadButton()
	}
}



extension HMenuView: HMenuButtonDelegate {


	
	func menuButton(_ button: HMenuButton) {
		if let subMenuButton = button as? HMenuItem,
			let indexOfItem = menuItems?.index(of: subMenuButton) {
			state = .none
			delegate?.menuView(self, didTapMenuItemAtIndex: indexOfItem)
		} else {
			state = state == .none ? .expand : .none
			delegate?.menuView(self, didTapMainButton: button as! HMainButton, state: state)
		}
	}
}
