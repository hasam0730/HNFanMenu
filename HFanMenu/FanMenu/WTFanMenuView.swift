//
//  WTMenuHandler.swift
//  HFanMenu
//
//  Created by Developer on 6/16/19.
//  Copyright © 2019 WhatsThat. All rights reserved.
//

import UIKit



public enum WTFanMenuState {
	
	case normal
	case expanded
}



public protocol WTMenuDelegate: class {
	
	func fanMenu(_ menuHandler: WTMenuHandler, didTapMainButton: WTMainButton, state: WTFanMenuState)
	func fanMenu(_ menuHandler: WTMenuHandler, didTapMenuItemAtIndex index: Int)
}



public protocol WTMenuDatasource: class {
	
	func numberOfSubButtons() -> Int
	func fanMenu(_ menuHandler: WTMenuHandler, menuItemAtIndex index: Int) -> WTSubButton
	func fanMenu(_ menuHandler: WTMenuHandler, menuLabelAtIndex index: Int) -> UILabel
}



public class WTMenuHandler {
	
	private var supperView: UIView
	private var mainButton: WTMainButton
	private var subButtons: [WTSubButton] = []
	private var subLabels: [UILabel] = []
	private var animator: HAnimator?
	private var radius: Double = 100
	
	
	
	weak var delegate: WTMenuDelegate?



	weak var datasource: WTMenuDatasource? {
		didSet {
			setupSubButtons()
		}
	}
	
	
	
	private(set) var state: WTFanMenuState = .normal {
		didSet {
			state == .expanded
			? animator?.showSubButtons(buttons: subButtons, labels: subLabels, completion: nil)
			: animator?.hideSubButtons(buttons: subButtons, labels: subLabels, completion: nil)
			
			animator?.animateMainButton(button: mainButton, state: state, completion: nil)
			mainButton.markButtonAsSelected(isSelected: state == .expanded)
		}
	}
	
	
	
	init(
		parentView: UIView,
		mainButon: WTMainButton,
		animator: HAnimator = HAnimator(),
		isClockWise: Bool,
		radius: Double) {
		self.state = .normal
		self.supperView = parentView
		self.mainButton = mainButon
		self.animator = animator
		self.radius = radius
		setUpMainButton()
	}
	
	
	
	private func setUpMainButton() {
		mainButton.delegate = self
		supperView.addSubview(mainButton)
		supperView.bringSubviewToFront(mainButton)
	}
	
	
	
	private func setupSubButtons() {
		guard let numberOfSubButtons = datasource?.numberOfSubButtons() else { return }
		for i in 0..<numberOfSubButtons {
			let button = datasource!.fanMenu(self, menuItemAtIndex: i)
			button.delegate = self
			supperView.addSubview(button)
			supperView.bringSubviewToFront(button)
			subButtons.append(button)
			
			let label = datasource!.fanMenu(self, menuLabelAtIndex: i)
			label.sizeToFit()
			subLabels.append(label)
			supperView.bringSubviewToFront(label)
			supperView.addSubview(label)
		}
		layoutSubButtons()
	}
	
	
	
	private func layoutSubButtons() {
		let theta = getTheta()
		var index = 0
		let center = CGPoint(x: mainButton.frame.midX, y: mainButton.frame.midY)
		subButtons.forEach { (item) in
			var x = 0.0
			var y = 0.0
			
			x = Double(center.x) - cos(Double(index) * theta) * radius
			y = Double(center.y) - sin(Double(index) * theta) * radius
			
			item.center = center
			item.startPosition = center
			item.endPosition = CGPoint(x: x, y: y)
			
			item.tag = index
			item.alpha = 0
			
			let label = subLabels[index]
			label.frame.origin = CGPoint(x: item.endPosition!.x - label.bounds.width, y: item.endPosition!.y)
			label.alpha = 0.0
			
			index += 1
		}
	}
	
	
	
	private func getTheta() -> Double {
		guard let datasource = datasource else { return .pi / 2 }
		let numberOfSubButtons: Double = Double(max(datasource.numberOfSubButtons() - 1, 1))
		return .pi / 2 / numberOfSubButtons
	}
}



extension WTMenuHandler: WTMenuButtonDelegate {



	func menuButton(_ button: WTMenuButton) {
		if let subMenuButton = button as? WTSubButton,
			let indexOfItem = subButtons.index(of: subMenuButton) {
			state = .normal
			delegate?.fanMenu(self, didTapMenuItemAtIndex: indexOfItem)
		} else {
			state = state == .normal ? .expanded : .normal
			delegate?.fanMenu(self, didTapMainButton: button as! WTMainButton, state: state)
		}
	}
}
