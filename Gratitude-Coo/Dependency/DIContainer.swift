//
//  DIContainer.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/17/25.
//

import Foundation
import SwiftData


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
    
    static func preview(modelContext: ModelContext) -> DIContainer {
        let container = DIContainer(service: StubService())
        // 필요한 경우 여기에 미리 보기용 데이터 추가
        return container
    }
}

