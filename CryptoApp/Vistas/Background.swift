//
//  Background.swift
//  CryptoApp
//
//  Created by Ulises Martínez on 29/07/24.
//

import SwiftUI

struct Background: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.color3, .color1, .color3, .color2]), startPoint: .topLeading, endPoint: .bottomTrailing)
        
       
        ZStack {
                Circle()
                .frame(width: 200, height: 300)
                .offset(x: -140, y: 125)
                .foregroundColor(.color3).opacity(0.7)
                .blur(radius: 4)
        }
    }
}

#Preview {
    Background()
}
