//
//  NameBillsCell.swift
//  ChargeAccount
//
//  Created by wd on 2022/5/13.
//

import UIKit

class NameBillsCell: UITableViewCell {

    @IBOutlet weak var billTypeLabel: UILabel!
    
    @IBOutlet weak var billTypeIcon: UIImageView!
    
    @IBOutlet weak var billTimeLabel: UILabel!
    
    @IBOutlet weak var billAmountLabel: UILabel!
    
    var billModel: BillModel? {
        didSet {
            billTypeIcon.image = UIImage(named: billModel?.type ?? "Other") ?? UIImage(named: "Other")
            billTypeLabel.text = billModel?.type
            billTimeLabel.text = billModel?.dateTime
            billAmountLabel.text = billModel?.money
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
