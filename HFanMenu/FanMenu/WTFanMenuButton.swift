//
//  WTMenuButton.swift
//  HFanMenu
//
//  Created by Developer on 6/16/19.
//  Copyright © 2019 WhatsThat. All rights reserved.
//

import UIKit



protocol WTMenuButtonDelegate: class {
	
	func menuButton(_ button: WTMenuButton)
}



@objcMembers
public class WTMenuButton: UIView {
	
	weak var delegate: WTMenuButtonDelegate?



	private lazy var imageView: UIImageView = {
		let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: bounds.size))
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	
	
	var image: UIImage? {
		didSet {
			imageView.image = image
		}
	}
	
	
	
	init(image: UIImage, frame: CGRect) {
		super.init(frame: frame)
		
		let sizeImage = CGSize(width: frame.size.width - 5, height: frame.size.height - 5)
		imageView.frame.size = sizeImage
		imageView.image = image
		addSubview(imageView)
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
		addGestureRecognizer(tapGesture)
	}
	
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
	@objc func didTap(_ gesture: UITapGestureRecognizer) {
		delegate?.menuButton(self)
	}
}



public class WTSubButton: WTMenuButton {
	
	public var startPosition: CGPoint?
	public var endPosition: CGPoint?
	
	
	
	convenience init(tagNumber: Int, image: UIImage, frame: CGRect) {
		self.init(image: image, frame: frame)
		self.tag = tagNumber
	}
}



public class WTMainButton: WTMenuButton {
	
	private var expandedImage: UIImage?
	private var defaultImage: UIImage?
	
	
	
	convenience init(image: UIImage, expandedImage: UIImage? = nil, frame: CGRect) {
		self.init(image: image, frame: frame)
		self.expandedImage = expandedImage
		self.defaultImage = image
	}
	
	
	
	func markButtonAsSelected(isSelected: Bool) {
		image = isSelected ? expandedImage : defaultImage
	}
}
