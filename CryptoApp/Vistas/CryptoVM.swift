//
//  CryptoVM.swift
//  CryptoApp
//
//  Created by Ulises Martínez on 28/07/24.
//

import Foundation


class CryptoVM: ObservableObject {
    @Published var cryptos: [Data] = []
    @Published var searchedCryptos: [Data] = []

    
    func fetchCryptos() async {
        let servicioApi = ServicioApi()
        do {
            let props = try await servicioApi.getCryptos()
            DispatchQueue.main.async { [self] in
                self.cryptos = props
            }
        } catch {
            print("Error fetching cryptos: \(error)")
        }
    }
    
    
    func searchCryptos(query: String) async {
         do {
             let servicioApi = ServicioApi()
             let results = try await servicioApi.searchCryptos(query: query)
             DispatchQueue.main.async { [self] in
                 self.searchedCryptos = results
             }
         } catch {
             print("Error searching cryptos: \(error)")
         }
     }

}
