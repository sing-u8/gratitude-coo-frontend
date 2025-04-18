//
//  DIContainer.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import Foundation

class DIContainer: ObservableObject {
 
    var service: ServiceProtocol
    
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
}

extension DIContainer {
    static var stub: DIContainer {
        .init(service: StubService())
    }
}

