//
//  Gratitude_CooApp.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/16/25.
//

import SwiftUI
import SwiftData

@main
struct Gratitude_CooApp: App {
    
    @StateObject var container: DIContainer = .init(service: ServiceImpl())
    
    var body: some Scene {
            
        WindowGroup {
            AuthenticatedView(authViewModel: .init(container: container))
                .environmentObject(container)
        }
    
    }
    
}
