//
//  BillModel.swift
//  ChargeAccount
//
//  Created by Lei on 2022/5/9.
//

import Foundation
import UIKit

struct BillModel: Codable {
    var id = UUID()
    var money: String
    var type: String
    var dateTime: String

    func date() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateTime)!
        return date
    }
}
