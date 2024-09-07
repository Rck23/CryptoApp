//
//  ContentView.swift
//  CryptoApp
//
//  Created by Ulises Martínez on 28/07/24.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        ZStack {
            Background()
            
            ListView()
            
        }.ignoresSafeArea()

    }
}

#Preview {
    ContentView()
}
