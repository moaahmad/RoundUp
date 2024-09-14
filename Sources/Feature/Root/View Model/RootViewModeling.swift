//
//  RootViewModeling.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Combine

protocol RootViewModeling {
    var rootDestination: CurrentValueSubject<RootDestination, Never> { get }
    var errorPublisher: PassthroughSubject<Error, Never> { get }

    func fetchData()
    func navigateTo(_ rootDestination: RootDestination)
}
