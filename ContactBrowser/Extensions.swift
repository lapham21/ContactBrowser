//
//  Extensions.swift
//  ContactBrowser
//
//  Created by Nolan Lapham on 9/15/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import Foundation

// MARK: - String Extensions

extension String {
    
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
    
}
