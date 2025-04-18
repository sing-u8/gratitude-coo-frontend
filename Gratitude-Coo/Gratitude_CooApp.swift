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



/*
 
 var sharedModelContainer: ModelContainer = {
     let schema = Schema([
         Item.self,
     ])
     let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

     do {
         return try ModelContainer(for: schema, configurations: [modelConfiguration])
     } catch {
         fatalError("Could not create ModelContainer: \(error)")
     }
 }()

 var body: some Scene {
     WindowGroup {
         ContentView()
     }
     .modelContainer(sharedModelContainer)
 }
 
 */
