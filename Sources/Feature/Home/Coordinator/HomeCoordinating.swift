//
//  HomeCoordinating.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Foundation

protocol HomeCoordinating: Coordinator {
    func presentRoundedUpViewController(transactions: [FeedItem])
}
