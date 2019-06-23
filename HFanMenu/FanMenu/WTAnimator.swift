//
//  HAnimator.swift
//  HFanMenu
//
//  Created by Developer on 6/16/19.
//  Copyright © 2019 WhatsThat. All rights reserved.
//

import UIKit



struct HAnimator {
	
	private var duration: TimeInterval!
	private var springWithDamping: CGFloat!
	private var springVelocity: CGFloat!
	private var isClockWise: Bool
	
	
	
	init(duration: TimeInterval = 0.5,
		 springWithDamping: CGFloat = 0.5,
		 springVelocity: CGFloat = 0.5,
		 isClockWise: Bool = true) {
		self.isClockWise = isClockWise
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
			options: [.curveEaseInOut],
			animations: animation,
			completion: completion)
	}
	
	
	
	func showSubButtons(buttons: [WTSubButton], labels: [UILabel], completion: (()->Void)?) {
		var delay: TimeInterval = 0
		if isClockWise {
			buttons.enumerated().forEach { index, button in
				animation(delay: delay, animation: {
					button.center = button.endPosition ?? CGPoint.zero
					button.alpha = 1.0
					labels[index].frame.origin = CGPoint(
						x: button.endPosition!.x - labels[index].bounds.width,
						y: button.endPosition!.y - button.bounds.height + 8)
					labels[index].alpha = 1.0
				}, completion: { isFinish in
				})
				delay += 0.2
			}
		} else {
			buttons.enumerated().reversed().forEach { index, button in
				animation(delay: delay, animation: {
					button.center = button.endPosition ?? CGPoint.zero
					button.alpha = 1.0
					labels[index].frame.origin = CGPoint(
						x: button.endPosition!.x - labels[index].bounds.width,
						y: button.endPosition!.y - button.bounds.height + 8)
					labels[index].alpha = 1.0
				}, completion: { isFinish in
				})
				delay += 0.2
			}
		}
	}
	
	
	
	func hideSubButtons(buttons: [WTSubButton], labels: [UILabel], completion: (() -> ())?) {
		var delay: TimeInterval = 0
		if isClockWise {
			buttons.enumerated().forEach { index, button in
				animation(delay: delay, animation: {
					button.center = button.startPosition ?? CGPoint.zero
					button.alpha = 0.0
					labels[index].frame.origin = button.startPosition ?? CGPoint.zero
					labels[index].alpha = 0.0
				}, completion: { isFinish in
				})
				delay += 0.2
			}
		} else {
			buttons.enumerated().reversed().forEach { index, button in
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
	}
	
	
	
	func animateMainButton(button: WTMainButton, state: WTFanMenuState, completion: (() -> ())?) {
		button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
		UIView.animate(
			withDuration: 1,
			delay: 0,
			usingSpringWithDamping: springWithDamping,
			initialSpringVelocity: springVelocity,
			options: .allowUserInteraction,
			animations: {
				button.transform = .identity
		}) { isFinish in
			guard isFinish else { return }
			completion?()
		}
	}
}
