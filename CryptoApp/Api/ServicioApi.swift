//
//  ServicioApi.swift
//  CryptoApp
//
//  Created by Ulises Martínez on 28/07/24.
//

import Foundation


class ServicioApi {
    
    //

    // https://api.coingecko.com/api/v3/coins/dogecoin?x_cg_demo_api_key=CG-xficR84Fr4XnEcjVbTvibCtJ
    // https://api.coingecko.com/api/v3/coins/markets?vs_currency=mxn&x_cg_demo_api_key=CG-xficR84Fr4XnEcjVbTvibCtJ
    
    let apiKey = "CG-xficR84Fr4XnEcjVbTvibCtJ"
    
    let urlApi = "https://api.coingecko.com/api/v3/coins"
    

    func getCryptos() async throws -> [Data]{
        let url = URL(string:"\(urlApi)/markets?vs_currency=mxn&limit=200&x_cg_demo_api_key=\(apiKey)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let propiedades = try JSONDecoder().decode( [Data].self, from: data)
        return propiedades
    }
        
    
    func searchCryptos(query: String) async throws -> [Data] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: "\(urlApi)/search?query=\(encodedQuery)&limit=200&x_cg_demo_api_key=\(apiKey)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let searchResult = try JSONDecoder().decode(SearchResponse.self, from: data)
        return searchResult.data
    }

    func parseHistoricalData(apiResponse: APIResponse) -> [HistoricalPrice] {
        var prices: [HistoricalPrice] = []
        
        for dailyData in apiResponse.prices {
            let timestamp = dailyData[0]
            let price = dailyData[1]
            
            // Convertir el timestamp a un objeto Date
            let date = Date(timeIntervalSince1970: timestamp)
            
            let historicalPrice = HistoricalPrice(date: date, price: price)
            prices.append(historicalPrice)
        }
        
        return prices
    }

    
    func getHistoricalPrices(for cryptoId: String) async throws -> [HistoricalPrice] {
        let url = URL(string: "\(urlApi)/\(cryptoId)/market_chart?vs_currency=mxn&days=7&x_cg_demo_api_key=\(apiKey)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        
        return parseHistoricalData(apiResponse: apiResponse)
    }

    
}
