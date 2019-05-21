//
//  UIFont+Utility.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/14/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    enum LSFonts {
        //Bold
        static let boldS20 = UIFont.systemFont(ofSize: 20, weight: .bold)
        static let boldS11 = UIFont.systemFont(ofSize: 11, weight: .bold)
        
        //Semibold
        static let semiBoldS18 = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        //Regular
        static let regS15 = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let regS11 = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
}
