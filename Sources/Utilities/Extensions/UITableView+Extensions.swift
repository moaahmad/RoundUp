//
//  UITableView+Extensions.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import UIKit

extension UITableView {
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }

    func beginRefreshing() {
        guard let refreshControl,
              !refreshControl.isRefreshing
        else {
            return
        }
        refreshControl.beginRefreshing()
        refreshControl.sendActions(for: .valueChanged)
    }

    func endRefreshing() {
        refreshControl?.endRefreshing()
    }
}
