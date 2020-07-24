//
//  TableViewAnimator.swift
//  TableViewAnimations
//
//  Created by Julian Llorensi on 23/07/2020.
//  Copyright © 2020 Julian Llorensi. All rights reserved.
//

import UIKit

typealias CellAnimation = (UITableViewCell, IndexPath, UITableView) -> Void

final class TableViewAnimator {
    private var animation: CellAnimation
    
    init(_ animation: @escaping CellAnimation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at index: IndexPath, in tableView: UITableView) {
        animation(cell, index, tableView)
    }
}

enum TableViewAnimatorFactory {
    /// fades the cell by setting alpha as zero and then animates the cell's alpha based on indexPaths
    static func fadeAnimation(duration: TimeInterval, delayFactor: TimeInterval) -> CellAnimation {
        return  { cell, indexPath, _ in
            cell.alpha = 0
            UIView.animate(withDuration: duration, delay: delayFactor * Double(indexPath.row), animations: {
                cell.alpha = 1
            })
        }
    }
    
    /// moves the cell downwards, then animates the cell's by returning them to their original position based on indexPaths
    static func moveUpAnimation(rowHeight: CGFloat, duration: TimeInterval, delayFactor: TimeInterval) -> CellAnimation {
        return { cell, indexPath, _ in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight * 1.4)
            UIView.animate(withDuration: duration, delay: delayFactor * Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    /// fades the cell by setting alpha as zero and moves the cell downwards, then animates the cell's alpha and returns it to it's original position based on indexPaths
    static func moveUpFadeAnimation(rowHeight: CGFloat, duration: TimeInterval, delayFactor: TimeInterval) -> CellAnimation {
        return { cell, indexPath, _ in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight * 1.4)
            cell.alpha = 0
            UIView.animate(withDuration: duration, delay: delayFactor * Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            })
        }
    }
    
    /// moves the cell downwards, then animates the cell's by returning them to their original position with spring bounce based on indexPaths
    static func moveUpBounceAnimation(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> CellAnimation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight)
            UIView.animate(withDuration: duration, delay: delayFactor * Double(indexPath.row), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
}

enum TableAnimation {
    case fadeIn(duration: TimeInterval, delay: TimeInterval)
    case moveUp(rowHeight: CGFloat, duration: TimeInterval, delay: TimeInterval)
    case moveUpWithFade(rowHeight: CGFloat, duration: TimeInterval, delay: TimeInterval)
    case moveUpWithBounce(rowHeight: CGFloat, duration: TimeInterval, delay: TimeInterval)
    
    var title: String {
        switch self {
        case .fadeIn(_, _):
            return "Fade-In Animation"
        case .moveUp(_, _, _):
            return "Move-Up Animation"
        case .moveUpWithFade(_, _, _):
            return "Move-Up-Fade Animation"
        case .moveUpWithBounce(_, _, _):
            return "Move-Up-Bounce Animation"
        }
    }
    
    func get() -> CellAnimation {
        switch self {
        case .fadeIn(let duration, let delay):
            return TableViewAnimatorFactory.fadeAnimation(duration: duration, delayFactor: delay)
        case .moveUp(let rowHeight, let duration, let delay):
            return TableViewAnimatorFactory.moveUpAnimation(rowHeight: rowHeight,
                                                            duration: duration, delayFactor: delay)
        case .moveUpWithFade(let rowHeight, let duration, let delay):
            return TableViewAnimatorFactory.moveUpFadeAnimation(rowHeight: rowHeight,
                                                                duration: duration, delayFactor: delay)
        case .moveUpWithBounce(let rowHeight, let duration, let delay):
            return TableViewAnimatorFactory.moveUpBounceAnimation(rowHeight: rowHeight,
                                                                  duration: duration, delayFactor: delay)
        }
    }
}
