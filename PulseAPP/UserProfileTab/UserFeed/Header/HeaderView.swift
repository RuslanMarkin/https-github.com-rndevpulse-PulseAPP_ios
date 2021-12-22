//
//  HeaderView.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 15.10.2021.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet weak var publicNameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var countPublicationsLabel: UILabel!
    @IBOutlet weak var countSubscriptionsLabel: UILabel!
    
    static func instantiate() -> HeaderView {
        let view: HeaderView = initFromNib()
        return view
    }
}

extension UIView {
    
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
