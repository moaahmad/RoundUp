//
//  HomeViewModeling.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Combine
import Foundation

protocol HomeViewModeling {
    var title: String { get }
    var emptyState: (message: String, description: String) { get }
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var userInfo: CurrentValueSubject<UserInfo, Never> { get }
    var feedItems: CurrentValueSubject<[FeedItem], Never> { get }
    var filteredFeedItems: PassthroughSubject<[FeedItem], Never> { get }
    var errorPublisher: PassthroughSubject<Error, Never> { get }
    var isFeedEmpty: Bool { get }

    func fetchData(completion: (() -> Void)?)
    func didTapRoundUp()
    func didChangeSegmentedControl(index: Int)
}
