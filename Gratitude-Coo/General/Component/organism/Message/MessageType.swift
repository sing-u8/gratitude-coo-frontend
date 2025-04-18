import Foundation


enum MessageType: String, CaseIterable {
    case fromSelfToSelf = "fromSelfToSelf"    // My message to myself
    case fromSelfToOther = "fromSelfToOther"  // My message to another user
    case fromOtherToSelf = "fromOtherToSelf"   // Message from another user to me
    
    var prefix: String {
        switch self {
        case .fromSelfToSelf:
            return ""  // No prefix needed
        case .fromSelfToOther:
            return "To"
        case .fromOtherToSelf:
            return "From"
        }
    }
    
    var title: String {
        switch self {
        case .fromSelfToSelf:
            return "To Me"
        case .fromSelfToOther:
            return "Sent"
        case .fromOtherToSelf:
            return "Received"
        }
    }
    
    var tabBarTitle: String {
        switch self {
        case .fromSelfToSelf:
            return "To Me"
        case .fromSelfToOther:
            return "Sent"
        case .fromOtherToSelf:
            return "Received"
        }
    }
}
