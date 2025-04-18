//
//  MainTabType.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import Foundation

enum MainTabType: String, CaseIterable {
    case home
    case search
    //case insight
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
            //case .insight:
            //return "Insight"
        }
    }
    
    func imageName(selected: Bool) -> String {
        selected ? "\(rawValue)_fill" : rawValue
    }
}
