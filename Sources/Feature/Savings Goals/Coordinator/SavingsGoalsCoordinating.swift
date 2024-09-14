//
//  SavingsGoalsCoordinating.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Foundation

protocol SavingsGoalsCoordinating: Coordinator {
    func presentCreateSavingsGoalVC(service: SavingsGoalsServicing)
}
