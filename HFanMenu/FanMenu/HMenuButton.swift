//
//  HMenuButton.swift
//  HFanMenu
//
//  Created by Developer on 6/16/19.
//  Copyright © 2019 WhatsThat. All rights reserved.
//

import UIKit



protocol HMenuButtonDelegate: class {
	
	func menuButton(_ button: HMenuButton)
}



@objcMembers
public class HMenuButton: UIView {
	
	weak var delegate: HMenuButtonDelegate?



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
	
	
	
	var size: CGSize? {
		didSet {
			guard let size = size else { return }
			frame.size = size
		}
	}
	
	
	
	init(image: UIImage, size: CGSize = CGSize(width: 50, height: 50)) {
		super.init(frame: CGRect.zero)
		self.image = image
		self.size = size
		frame.size = size
		imageView.image = image
		
		let sizeImage = CGSize(width: frame.size.width , height: frame.size.height)
		imageView.frame.size = sizeImage
		imageView.center = center
		
		
		
		// imageView.frame.size = CGSize(width: image.size.width + 10, height: image.size.height + 30)
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
		addGestureRecognizer(tapGesture)
		addSubview(imageView)
	}
	
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
	@objc func didTap(_ gesture: UITapGestureRecognizer) {
		delegate?.menuButton(self)
	}
}



public class HMenuItem: HMenuButton {
	
	public var startPosition: CGPoint?
	public var endPosition: CGPoint? {
		didSet {
			
		}
	}
	
	
	
	convenience init(tagNumber: Int, image: UIImage, size: CGSize) {
		self.init(image: image, size: size)
		self.tag = tagNumber
		
		
	}
}



public class HMainButton: HMenuButton {
	
	private var selectedImage: UIImage?
	private var unselectedImage: UIImage?
	
	
	
	convenience init(image: UIImage, selectedImage: UIImage? = nil, size: CGSize) {
		self.init(image: image, size: size)
		self.selectedImage = selectedImage
		self.unselectedImage = image
	}
	
	
	
	func markButtonAsSelected(isSelected: Bool) {
		image = isSelected ? selectedImage : unselectedImage
	}
}
