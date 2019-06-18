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
			usingSpringWithDamping: 1,
			initialSpringVelocity: 0.5,
			options: [.curveEaseInOut],
			animations: animation,
			completion: completion)
	}
	
	
	
	func showItems(items: [HMenuItem], labels: [UILabel], completion: (()->Void)?) {
		var delay: TimeInterval = 0
		items.enumerated().forEach { index, button in
			animation(delay: delay, animation: {
				button.center = button.endPosition ?? CGPoint.zero
				button.alpha = 1.0
				labels[index].frame.origin = CGPoint(
					x: button.endPosition!.x - labels[index].bounds.width,
					y: button.endPosition!.y - button.bounds.height)
				labels[index].alpha = 1.0
			}, completion: { isFinish in
			})
			delay += 0.2
		}
	}
	
	
	
	func hideItems(items: [HMenuItem], labels: [UILabel], completion: (() -> ())?) {
		var delay: TimeInterval = 0
		items.enumerated().forEach { index, button in
			animation(delay: delay, animation: {
				button.center = button.startPosition ?? CGPoint.zero
				button.alpha = 0.0
				labels[index].frame.origin = button.startPosition ?? CGPoint.zero
				labels[index].alpha = 0.0
			}, completion: { isFinish in
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
