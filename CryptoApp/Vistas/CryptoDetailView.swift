import SwiftUI
import SDWebImageSwiftUI
import Charts

struct CryptoDetailView: View {
    var data: Data
    @State private var historicalPrices: [HistoricalPrice] = []

    var body: some View {
        VStack{
            WebImage(url: URL(string: data.image))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding()
            
            VStack(alignment: .center, spacing: 20){
                HStack {
                    
                    Text(data.name)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.color4)
                        .multilineTextAlignment(.center)
                    
                        .padding(.horizontal, 10)
                    
                    Text(data.symbol)
                        .font(.title)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                }

                HStack {
                    Text("Precio actual:")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.color4)

                    Spacer()

                    Text("Mxn")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.gray)
                        .padding(2)
                    Text("$\(data.currentPrice, specifier: "%.4f")")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.color4)

                }
                
                HStack {
                    Text("Cambio en 24 horas:")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.color4)

                    Spacer()
                    Text("\(data.priceChange24H, specifier: "%.2f")")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.color4)
                }
                
                HStack {
                    Text("% en 24 horas:")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.color4)

                    Spacer()
                    Text("\(data.priceChangePercentage24H, specifier: "%.2f%%")")
                        .font(.title3)
                        .bold()
                        .foregroundColor(data.priceChangePercentage24H >= 0 ? .green : .red)
                }
                
                HStack {
                    Text("Máximo:")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.color4)

                    Spacer()
                    Text("$\(data.ath, specifier: "%.2f")")
                        .font(.title3)
                        .bold()
                        .foregroundColor(data.ath >= 0 ? .green : .red)
                }
                
                
                HStack {
                    Text("% Max. Historico:")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.color4)

                    Spacer()
                    Text("\(data.athChangePercentage, specifier: "%.2f%%")")
                        .font(.title3)
                        .bold()
                        .foregroundColor(data.athChangePercentage >= 0 ? .green : .red)
                }
                
                

                
                HStack {
                    Text("Minimo:")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.color4)

                    Spacer()
                    Text("$\(data.atl, specifier: "%.2f")")
                        .font(.title3)
                        .bold()
                        .foregroundColor(data.atl >= 0 ?  .green : .red)
                }
                
                
                HStack {
                    Text("% Min. Historico:")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.color4)

                    Spacer()
                    Text("\(data.atlChangePercentage, specifier: "%.2f%%")")
                        .font(.title3)
                        .bold()
                        .foregroundColor(data.atlChangePercentage >= 0 ?  .green : .red)
                }
                
             



                HStack {
                    Text("Cap. de mercado:")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.color4)

                    Spacer()
                    Text("Mxn")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.gray)
                        .padding(2)
                    Text("$\(data.marketCap)")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.color4)
                }
                
                HStack {
                    Text("High 24H:")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.color4)

                    Spacer()
                    Text("$\(data.high24H, specifier: "%.2f")")
                        .font(.title3)
                        .bold()
                        .foregroundColor(data.high24H >= 0 ? .green : .red)
                }
                
                HStack {
                    Text("Low 24H:")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.color4)

                    Spacer()
                    Text("$\(data.low24H, specifier: "%.2f")")
                        .font(.title3)
                        .bold()
                        .foregroundColor(data.low24H >= 0 ? .red : .green)
                }
                
                Spacer()
               
            }.padding(.horizontal, 16)
         
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [.color3, .color1, .color3, .color4]), startPoint: .topTrailing, endPoint: .bottomLeading))
        .ignoresSafeArea()
        .task {
            do {
                let prices = try await ServicioApi().getHistoricalPrices(for: data.id)
                    historicalPrices = prices
            } catch {
                print("Error al obtener los precios históricos: \(error)")
                }
            }
    }
}


