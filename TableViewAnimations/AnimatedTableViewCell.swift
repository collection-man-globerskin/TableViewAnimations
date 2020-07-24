//
//  AnimatedTableViewCell.swift
//  TableViewAnimations
//
//  Created by Julian Llorensi on 23/07/2020.
//  Copyright © 2020 Julian Llorensi. All rights reserved.
//

import UIKit

class AnimatedTableViewCell: UITableViewCell {
    @IBOutlet private weak var containerView: UIView!
    
    private var colors: [UIColor] = [UIColor.systemBlue, .systemRed, .systemOrange, .systemPurple, .systemGreen]
    private var color = UIColor.white {
        didSet {
            containerView.backgroundColor = color
        }
    }
    
    static let height: CGFloat = 64

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        color = colors.randomElement() ?? .white
        containerView.layer.cornerRadius = 4
    }
    
    override class func description() -> String {
        return "AnimatedTableViewCell"
    }
}
