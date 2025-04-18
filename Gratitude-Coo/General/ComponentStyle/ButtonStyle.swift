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
    let strokeWidth: CGFloat
    
    init(
        textColor: Color = .txPrimary,
        borderColor: Color = .bdSub,
        backgroundColor: Color = .itBgPri,
        fontSize: CGFloat = 17,
        strokeWidth: CGFloat = 1
    ) {
        self.textColor = textColor
        self.borderColor = borderColor
        self.fontSize = fontSize
        self.backgroundColor = backgroundColor
        self.strokeWidth = strokeWidth
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: fontSize))
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: strokeWidth)
            )
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

