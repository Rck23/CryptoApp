//
//  ListView.swift
//  CryptoApp
//
//  Created by Ulises Martínez on 29/07/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ListView: View {
    
    @State var buscarCrypto:String = ""
    @State var cargando:Bool = false
    @StateObject var cryptoVM = CryptoVM()
    
    @State private var mostrarModal: Bool = false
    @State private var criptomonedaSeleccionada: Data? = nil
    
    var body: some View {
        
        VStack {
            Text("Criptomonedas").font(.largeTitle).bold().foregroundStyle(LinearGradient(colors: [.indigo, .color4], startPoint: .topLeading, endPoint: .bottomLeading)).multilineTextAlignment(.leading)
            
            TextField("", text: $buscarCrypto, prompt: Text("Buscar criptomoneda...").font(.title3).bold().foregroundColor(.color4 .opacity(0.5)))
                .padding()
                .background(Color.indigo.opacity(0.2))
                .cornerRadius(20)
                .font(.title3)
                .foregroundColor(.color4)
                .padding(.horizontal, 20)
                .autocorrectionDisabled()
                .onChange(of: buscarCrypto) { oldValue, newValue in
                    cargando = true
                    Task {
                        await cryptoVM.searchCryptos(query: newValue)
                        cargando = false
                    }
                    
                }
            
            ZStack{
                
                if cargando{
                    
                    ProgressView().tint(.color1).frame(width: 300, height: 300)
                }
                
                CryptosView(cryptoVM: cryptoVM, searchText: $buscarCrypto, mostrarModal: $mostrarModal, criptomonedaSeleccionada: $criptomonedaSeleccionada)
                
            } .sheet(isPresented: $mostrarModal) {
                if let crypto = criptomonedaSeleccionada {
                    CryptoDetailView(data: crypto)
                }
            }
            
            
        }
        
    }
}

struct CryptosView: View {
    @StateObject var cryptoVM = CryptoVM()
    @Binding var searchText: String
    @State var cargando:Bool = false
    
    @Binding var mostrarModal: Bool
    @Binding var criptomonedaSeleccionada: Data?
    
    var body: some View {
        ZStack(alignment: .center) {
            // Fondo semi-transparente
            LinearGradient(colors: [.white, .indigo], startPoint: .top, endPoint: .bottom).opacity(0.6)
                .frame(width: 350, height: 600)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                .blur(radius: 1)
            
            
            // Contenido principal
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(cryptoVM.cryptos.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }, id: \.id) { crypto in
                            
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(crypto.marketCapRank)")
                                        .font(.headline)
                                        .foregroundColor(.black.opacity(0.6))
                                        .padding(5)
                                    WebImage(url: URL(string: crypto.image))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                    
                                    VStack (alignment: .leading) {
                                        Text(crypto.name)
                                            .foregroundColor(.black)
                                            .font(.headline)
                                        Text(crypto.symbol)
                                            .font(.subheadline)
                                            .foregroundColor(.black.opacity(0.6))
                                    }
                                    
                                    Spacer()
                                    
                                    VStack (alignment: .trailing) {
                                        Text("$ \(crypto.currentPrice, specifier: "%.2f") ")
                                            .font(.system(size: 16))
                                            .bold()
                                            .foregroundColor(.black)
                                        
                                        Text("\(crypto.priceChangePercentage24H, specifier: "%.3f")%")
                                            .font(.subheadline)
                                            .foregroundColor(crypto.priceChangePercentage24H >= 0 ? .verde : .red)
                                    }
                                    
                                }
                                Divider().background(Color.black)
                            }
                            .onTapGesture {
                                // Mostrar modal al seleccionar la criptomoneda
                                criptomonedaSeleccionada = crypto
                                mostrarModal = true
                            }
                        }
                    }
                }
                .onAppear {
                    Task {
                        await cryptoVM.fetchCryptos()
                    }
                }
                
            }
            .padding()
            .frame(width: 350, height: 600)
            .foregroundColor(Color.black.opacity(0.8))
        }
    }
}



#Preview {
    ListView()
}
