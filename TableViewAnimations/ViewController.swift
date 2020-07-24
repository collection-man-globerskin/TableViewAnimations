//
//  ViewController.swift
//  TableViewAnimations
//
//  Created by Julian Llorensi on 23/07/2020.
//  Copyright © 2020 Julian Llorensi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var fadeInButton: UIButton!
    @IBOutlet private weak var moveUpButton: UIButton!
    @IBOutlet private weak var moveUpFadeButton: UIButton!
    @IBOutlet private weak var moveUpBounceButton: UIButton!
    
    private enum Constants {
        static let numberOfCells: Int = 6
        static let duration: TimeInterval = 0.85
        static let delay: TimeInterval = 0.05
        static let fontSize: CGFloat = 26
        static let tableViewHeaderHeight: CGFloat = 72
        static let headerContentHeight: CGFloat = 42
    }
    
    private var tableViewHeaderText: String = ""
    private var currentAnimation: TableAnimation = .fadeIn(duration: Constants.duration, delay: Constants.delay) {
        didSet {
            tableViewHeaderText = currentAnimation.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewHeaderText = currentAnimation.title
        
        fadeInButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        moveUpButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        moveUpFadeButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        moveUpBounceButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        tableView.register(UINib(nibName: AnimatedTableViewCell.description(), bundle: nil), forCellReuseIdentifier: AnimatedTableViewCell.description())
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.separatorStyle = .none
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            currentAnimation = .fadeIn(duration: Constants.duration, delay: Constants.delay)
        case 2:
            currentAnimation = .moveUp(rowHeight: AnimatedTableViewCell.height, duration: Constants.duration, delay: Constants.delay)
        case 3:
            currentAnimation = .moveUpWithFade(rowHeight: AnimatedTableViewCell.height, duration: Constants.duration, delay: Constants.delay)
        case 4:
            currentAnimation = .moveUpWithBounce(rowHeight: AnimatedTableViewCell.height, duration: Constants.duration, delay: Constants.delay)
        default:
            break
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AnimatedTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.tableViewHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnimatedTableViewCell.description(), for: indexPath) as? AnimatedTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = currentAnimation.get()
        let animator = TableViewAnimator(animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: Constants.headerContentHeight))
        headerView.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.frame = CGRect(x: 24, y: 12, width: self.view.frame.width, height: Constants.headerContentHeight)
        label.text = tableViewHeaderText
        label.textColor = UIColor.label
        label.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .medium)
        headerView.addSubview(label)
        
        return headerView
    }
}

