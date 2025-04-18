//
//  TextStyle.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/16/25.
//

import SwiftUI

struct TextStyle: ViewModifier {
    enum SizeType {
        case largeTitle
        case title1
        case title2
        case title3
        case headline
        case body
        case callout
        case subheadline
        case footnote
        case caption
        
        var size: CGFloat {
            switch self {
            case .largeTitle:
                return 34
            case .title1:
                return 28
            case .title2:
                return 22
            case .title3:
                return 20
            case .headline:
                return 17
            case .body:
                return 17
            case .callout:
                return 16
            case .subheadline:
                return 15
            case .footnote:
                return 13
            case .caption:
                return 12
            }
        }
    }
    
    enum WeightType {
        case regular
        case medium
        case semibold
        case bold
        case heavy
        
        var weight: Font.Weight {
            switch self {
            case .regular:
                return .regular
            case .medium:
                return .medium
            case .semibold:
                return .semibold
            case .bold:
                return .bold
            case .heavy:
                return .heavy
            }
        }
    }
    
    let size: SizeType
    let weight: WeightType
    let color: Color?
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size.size, weight: weight.weight))
            .if(color != nil) { view in
                view.foregroundColor(color)
            }
    }
}

extension View {
    func textStyle(size: TextStyle.SizeType = .body, weight: TextStyle.WeightType = .regular, color: Color? = nil) -> some View {
        modifier(TextStyle(size: size, weight: weight, color: color))
    }
    
    // 이 부분 나중에 다시 공부하기
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
