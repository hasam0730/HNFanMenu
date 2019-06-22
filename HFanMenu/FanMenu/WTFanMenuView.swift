//
//  HMenuView.swift
//  HFanMenu
//
//  Created by Developer on 6/16/19.
//  Copyright © 2019 WhatsThat. All rights reserved.
//

import UIKit



public enum HMenuViewState {
	
	case none
	case expand
}



public protocol HMenuDelegate: class {
	
	func menuView(_ menuView: HMenuView, didTapMainButton: HMainButton, state: HMenuViewState)
	func menuView(_ menuView: HMenuView, didTapMenuItemAtIndex index: Int)
}



public protocol HMenuDatasource: class {
	
	func numberOfItems() -> Int
	func menuView(_ menuView: HMenuView, menuItemAtIndex index: Int) -> HMenuItem
	func menuView(_ menuView: HMenuView, menuLabelAtIndex index: Int) -> UILabel
}



public class HMenuView {
	
	private var supperView: UIView?
	private var mainButton: HMainButton?
	private var subButtons: [HMenuItem]? = []
	private var subLabels: [UILabel]? = []
	private var animator: HAnimator?
	
	public var isClockWise = true
	public var radius: Double = 100
	
	var datasource: HMenuDatasource?
	var delegate: HMenuDelegate?
	
	
	
	private(set) var state: HMenuViewState = .none {
		didSet {
			guard let mainButton = mainButton,
				let menuItems = subButtons,
				let labels = subLabels else { return }
			
			state == .expand
			? animator?.showItems(items: menuItems, labels: labels, completion: nil)
			: animator?.hideItems(items: menuItems, labels: labels, completion: nil)
			
			animator?.animateMainButton(button: mainButton, state: state, completion: nil)
			mainButton.markButtonAsSelected(isSelected: state == .expand)
		}
	}
	
	
	
	init(parentView: UIView,
		 mainButon: HMainButton?,
		 animator: HAnimator,
		 isClockWise: Bool,
		 radius: Double) {
		self.supperView = parentView
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
		guard let parentView = supperView else { return }
		setUpDefaultHomeButtonPosition()
		mainButton?.delegate = self
		mainButton?.backgroundColor = .green
		parentView.addSubview(mainButton!)
		parentView.bringSubviewToFront(mainButton!)
	}
	
	
	
	fileprivate func setUpDefaultHomeButtonPosition() {
		guard let parentView = supperView else { return }
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
			supperView?.addSubview(button)
			supperView?.bringSubviewToFront(button)
			subButtons?.append(button)
			
			let label = datasource!.menuView(self, menuLabelAtIndex: i)
			label.sizeToFit()
			subLabels?.append(label)
			supperView?.bringSubviewToFront(label)
			supperView?.addSubview(label)
		}
	}
	
	
	
	private func removeButton() {
		let _ =  subButtons?.map { $0.removeFromSuperview() }
		subButtons?.removeAll()
	}
	
	
	
	private func layoutButton() {
		let theta = getTheta()
		let flip: Double = isClockWise ? 1 : -1
		var index = 0
		let center = CGPoint(x: mainButton!.frame.midX, y: mainButton!.frame.midY)
		subButtons?.forEach { (item) in
			var x = 0.0
			var y = 0.0
			x = Double(center.x) - cos(Double(index) * theta) * radius * flip
			y = Double(center.y) - sin(Double(index) * theta) * radius
			
			item.center = center
			item.startPosition = center
			item.endPosition = CGPoint(x: x, y: y)
			
			item.tag = index
			item.alpha = 0
			
			if let label = subLabels?[index] {
				label.frame.origin = CGPoint(x: item.endPosition!.x - label.bounds.width, y: item.endPosition!.y)
				label.alpha = 0.0
			}
			
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
	
	
	
	open func setHomeButtonPosition(position: CGPoint) {
		mainButton?.center = position
		reloadButton()
	}
}



extension HMenuView: HMenuButtonDelegate {


	
	func menuButton(_ button: HMenuButton) {
		if let subMenuButton = button as? HMenuItem,
			let indexOfItem = subButtons?.index(of: subMenuButton) {
			state = .none
			delegate?.menuView(self, didTapMenuItemAtIndex: indexOfItem)
		} else {
			state = state == .none ? .expand : .none
			delegate?.menuView(self, didTapMainButton: button as! HMainButton, state: state)
		}
	}
}
