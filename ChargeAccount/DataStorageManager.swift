//
//  DataStorageManager.swift
//  ChargeAccount
//
//  Created by Lei on 2022/5/9.
//

import Foundation

let kUserdefaultsBillsList = "kBillsList"

struct DataStorageManager: Codable {
    
    // Enum for data error
    enum DataError: Error {
        case dataNotFound
        case dataNotSaved
    }
    
    // Store Data
    func storeBills(bills: [BillModel]) throws {
        let data = try JSONEncoder().encode(bills)
        UserDefaults.standard.set(data, forKey: kUserdefaultsBillsList)
        UserDefaults.standard.synchronize()
    }
    
    // Read Write Data
    func readBillModels() throws -> [BillModel] {
        guard let data = UserDefaults.standard.data(forKey: kUserdefaultsBillsList) else { return [] }
        if let billModels = try? JSONDecoder().decode([BillModel].self, from: data) {
            return billModels
        }
        
        throw DataError.dataNotFound
    }
    
    /// Update Bill
    func updateBill(_ bill: BillModel) throws {
        guard let data = UserDefaults.standard.data(forKey: kUserdefaultsBillsList) else { return }
        if var billModels = try? JSONDecoder().decode([BillModel].self, from: data) {
            
            if let index = billModels.firstIndex(where: {$0.id == bill.id}) {
                billModels[index] = bill
            }
            let data = try JSONEncoder().encode(billModels)
            UserDefaults.standard.set(data, forKey: kUserdefaultsBillsList)
        }
    }
    
    /// Delete Bill
    func deleteBill(_ bill: BillModel) throws {
        guard let data = UserDefaults.standard.data(forKey: kUserdefaultsBillsList) else { return }
        if var billModels = try? JSONDecoder().decode([BillModel].self, from: data) {
            
            billModels = billModels.filter({ $0.id != bill.id })
            
            let data = try JSONEncoder().encode(billModels)
            UserDefaults.standard.set(data, forKey: kUserdefaultsBillsList)
        }
    }
}
