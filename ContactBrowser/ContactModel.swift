//
//  contactModel.swift
//  ContactBrowser
//
//  Created by Nolan Lapham on 9/12/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import Foundation
import Contacts

class ContactModel
{    
    var contacts = [String: [CNContact]]()
    
    var filteredContacts = [String: [CNContact]]()
    
    var data = [CNContact]()
    
//    func loadDictionary() {
//        // Build letters array:
//        
//        var letters: [Character]
//        
//        letters = data.map { (name) -> Character in
//            return name.givenName.characters.first!
//        }
//        
//        letters = letters.sorted()
//        
//        letters = letters.reduce([], { (list, name) -> [Character] in
//            if !list.contains(name) {
//                return list + [name]
//            }
//            return list
//        })
//        
//        
//        // Build contacts array:
//        
//        for entry in data {
//            
//            if contacts[String(describing: entry.givenName.characters.first)] == nil {
//                contacts[String(describing: entry.givenName.characters.first)] = [CNContact]()
//            }
//            
//            contacts[String(describing: entry.givenName.characters.first)]!.append(entry)
//            
//        }
//        
//        for list in contacts.keys {
//            contacts[list]?.sort()
//        }
//    }
    
}
