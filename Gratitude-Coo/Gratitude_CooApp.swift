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
    
    let modelContainer: ModelContainer = {
        let schema = Schema([User.self])
        let modelConfiguration = ModelConfiguration(schema: schema)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }()
    
    
    var body: some Scene {
        
        WindowGroup {
            AuthenticatedView(authViewModel: .init(container: container, modelContext: modelContainer.mainContext))
                .environmentObject(container)
                .modelContainer(modelContainer)
        }
        
    }
    
}
