//
//  HAnimator.swift
//  HFanMenu
//
//  Created by Developer on 6/16/19.
//  Copyright © 2019 WhatsThat. All rights reserved.
//

import UIKit



struct HAnimator {
	
	var duration: TimeInterval!
	var springWithDamping: CGFloat!
	var springVelocity: CGFloat!
	
	
	
	init(duration: TimeInterval = 0.5,
		 springWithDamping: CGFloat = 0.5,
		 springVelocity: CGFloat = 0.5) {
		self.duration = duration
		self.springWithDamping = springWithDamping
		self.springVelocity = springVelocity
	}
	
	
	
	private func animation(
		delay: TimeInterval,
		animation: @escaping () -> Void,
		completion: @escaping (Bool) -> Void) {
		UIView.animate(
			withDuration: duration,
			delay: delay,
			usingSpringWithDamping: springWithDamping,
			initialSpringVelocity: springVelocity,
			options: .curveEaseInOut,
			animations: animation,
			completion: completion)
	}
	
	
	
	func showItems(items: [HMenuItem], completion: (()->Void)?) {
		var delay: TimeInterval = 0
		items.forEach { button in
			animation(delay: delay, animation: {
				button.center = button.endPosition ?? CGPoint.zero
				button.alpha = 1.0
			}, completion: { isFinish in
				// TODO: handle completion here
			})
			delay += 0.2
		}
	}
	
	
	
	func hideItems(items: [HMenuItem], completion: (() -> ())?) {
		var delay: TimeInterval = 0
		items.forEach { button in
			animation(delay: delay, animation: {
				button.center = button.startPosition ?? CGPoint.zero
				button.alpha = 0.0
			}, completion: { isFinish in
				// TODO: handle completion here
			})
			delay += 0.2
		}
	}
	
	
	
	func animateMainButton(button: HMainButton, state: HMenuViewState, completion: (() -> ())?) {
		let scale: CGFloat = state == .expand ? 1.0 : 0.9
		let transform = CGAffineTransform(scaleX: scale, y: scale)
		animation(delay: 0, animation: {
			button.transform = transform
		}) { isFinish in
			guard isFinish else { return }
			completion?()
		}
	}
}
