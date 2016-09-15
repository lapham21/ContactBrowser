//
//  ContactViewModel.swift
//  ContactBrowser
//
//  Created by Nolan Lapham on 9/13/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import Foundation
import Contacts

class ContactViewModel
{
    
    private var store = CNContactStore()
    
    var shouldShowSearchResults = false
    
    var contactModel = ContactModel()
    
    func loadContacts() {
        let toFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: toFetch as [CNKeyDescriptor])
        
        do {
            try store.enumerateContacts(with: request) {
                contact, stop in
                if contact.phoneNumbers.description != "" {         // Prevents adding the contact if there is no phone number
                    
                    if self.contactModel.contacts[String(contact.givenName.characters.first!)] == nil {
                        self.contactModel.contacts[String(contact.givenName.characters.first!)] = [CNContact]()
                    }
                    
                    self.contactModel.contacts[String(contact.givenName.characters.first!)]!.append(contact)
                }
            }
        } catch let err {
            print(err)
        }
        
        // Sort the contactModel.contacts Dictionary alphabetically for each key
        for key in contactModel.contacts.keys {
            contactModel.contacts[key]?.sort {
                $0.givenName < $1.givenName
            }
        }
    }
    
    func loadFilteredContacts(filterString: String) {
        let toFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: toFetch as [CNKeyDescriptor])
        
        do {
            try store.enumerateContacts(with: request) {
                contact, stop in
                if contact.givenName.hasPrefix(filterString) || ((contact.phoneNumbers[0].value).value(forKey: "digits") as! String).hasPrefix(filterString) {
                    if contact.phoneNumbers.description != "" {         // Prevents adding the contact if there is no phone number
                        self.contactModel.filteredContacts.append(contact)
                    }
                }
            }
        } catch let err {
            print(err)
        }
        contactModel.filteredContacts.sort { $0.givenName < $1.givenName }
    }
    
    func resetFilteredContactArray() {
        contactModel.filteredContacts.removeAll()
    }
    
    private let Alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    func titleForHeaderInSection(section: Int) -> String? {
        
        if (shouldShowSearchResults) {
            return nil
        } else {
            return Alphabet[section]
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        var rows = 0
        
        if (shouldShowSearchResults) {
            return contactModel.filteredContacts.count
        } else {
            if let contact = contactModel.contacts[Alphabet[section]] {
                rows = contact.count
            }
        }
        return rows
        
    }
    
    func contactAtIndex(indexPath: IndexPath) -> CNContact {
        
        var contact = CNContact()
        
        if (shouldShowSearchResults) {
            contact = contactModel.filteredContacts[indexPath.row]
        } else {
            contact = (contactModel.contacts[Alphabet[indexPath.section]]?[indexPath.row])!
        }
        
        return contact
        
    }
    
    func returnAlphabetArray() -> [String] {
        return Alphabet
    }
    
    func sectionForSectionIndexTitle(title: String, index: Int) -> Int {
        
        if let indexOfAlphabetArray = Alphabet.index(of: title) {
            let sectionForIndexTitle = Int(indexOfAlphabetArray)
            return sectionForIndexTitle
        }
        return 0
        
    }
    
    func phoneNumberStringModifier(contact: CNContact) -> String {
        
        var phoneNumber = "(\((contact.phoneNumbers[0].value).value(forKey: "digits") as! String)"
        phoneNumber = phoneNumber.insert(string: ") ", ind: 4)
        phoneNumber = phoneNumber.insert(string: "-", ind: 9)
        return phoneNumber
        
    }
    
}
