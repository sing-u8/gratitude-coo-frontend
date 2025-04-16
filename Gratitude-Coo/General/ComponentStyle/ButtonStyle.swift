//
//  ButtonStyle.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/16/25.
//

import SwiftUI

struct BtStyle: ButtonStyle {
    let textColor: Color
    let borderColor: Color
    let backgroundColor: Color
    let fontSize: CGFloat
    
    init(textColor: Color = .txPrimary, borderColor: Color = .bdSub, backgroundColor: Color = .itBgPri ,fontSize: CGFloat = 17) {
        self.textColor = textColor
        self.borderColor = borderColor
        self.fontSize = fontSize
        self.backgroundColor = backgroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: fontSize))
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity, maxHeight: 48)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 0.8)
            }
            .padding(.horizontal, 15)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}

