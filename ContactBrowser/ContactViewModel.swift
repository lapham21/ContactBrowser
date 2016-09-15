//
//  ContactViewModel.swift
//  ContactBrowser
//
//  Created by Nolan Lapham on 9/13/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import Foundation
import Contacts

class ContactViewModel {
    
    private var filteredContacts = [CNContact]()
    
    private var store = CNContactStore()
    
    var shouldShowSearchResults = false
    
    private var contactModel = ContactModel()
    
    func loadContacts(completion: @escaping () -> ()) {
        
        DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
            self?.loadContacts()
            DispatchQueue.main.async { () -> Void in
                completion()
            }
        }
    }
    
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
        
        for key in contactModel.contacts.keys {
            contactModel.contacts[key]?.sort {
                $0.givenName < $1.givenName
            }
        }
    }
    
    func loadFilteredContacts(searchText: String, completion: @escaping () -> ()) {
        
        if searchText != "" {
            shouldShowSearchResults = true
            resetFilteredContactArray()
            DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
                self?.loadFilteredContacts(filterString: searchText)
                DispatchQueue.main.async { () -> Void in
                    completion()
                }
            }
        } else {
            shouldShowSearchResults = false
            completion()
        }
        
    }
    
    func loadFilteredContacts(filterString: String) {
        
        for (_, contacts) in self.contactModel.contacts {
            for contact in contacts {
                if contact.givenName.hasPrefix(filterString) || ((contact.phoneNumbers[0].value).value(forKey: "digits") as! String).hasPrefix(filterString) {
                    if contact.phoneNumbers.description != "" {         // Prevents adding the contact if there is no phone number
                        self.filteredContacts.append(contact)
                    }
                }
            }
        }
        
        filteredContacts.sort { $0.givenName < $1.givenName }
    }
    
    func resetFilteredContactArray() {
        filteredContacts.removeAll()
    }
    
    private let Alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    func titleForHeaderInSection(section: Int) -> String? {
        
        if (shouldShowSearchResults) {
            return nil
        } else {
            return Alphabet[section]
        }
    }
    
    func numberOfSections() -> Int {
        
        var sections = 0
        
        if (shouldShowSearchResults) {
            return 1
        } else {
            for _ in contactModel.contacts.keys {
                sections += 1
            }
        }
        return sections
        
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        var rows = 0
        
        if (shouldShowSearchResults) {
            return filteredContacts.count
        } else {
            if let contact = contactModel.contacts[Alphabet[section]] {
                rows = contact.count
            }
        }
        return rows
        
    }
    
    func contactAtIndexPath(indexPath: IndexPath) -> CNContact {
        
        var contact = CNContact()
        
        if (shouldShowSearchResults) {
            contact = filteredContacts[indexPath.row]
        } else {
            contact = (contactModel.contacts[Alphabet[indexPath.section]]?[indexPath.row])!
        }
        
        return contact
        
    }
    
    func alertControllerMessageForContactAtIndexPath(indexPath: IndexPath) -> String {
        
        let contact = contactAtIndexPath(indexPath: indexPath)
        let contactName = "\(contact.givenName) \(contact.familyName)"
        let phoneNumber = phoneNumberFancyStringForContactAtIndexPath(indexPath: indexPath)
        
        return "Would you like to call \(contactName) at number: \(phoneNumber)?"
    }
    
    func urlForPlacingACallToContactAtIndexPath(indexPath: IndexPath) -> URL? {
        
        let contact = contactAtIndexPath(indexPath: indexPath)
        let phoneNumberForCalling = (contact.phoneNumbers[0].value).value(forKey: "digits") as! String
        return URL(string: "tel://\(phoneNumberForCalling)")

    }
    
    func phoneNumberForContactAtIndexPath(indexPath: IndexPath) -> String {
        
        let contact = contactAtIndexPath(indexPath: indexPath)
        return (contact.phoneNumbers[0].value).value(forKey: "digits") as! String
        
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
    
    func phoneNumberFancyStringForContactAtIndexPath(indexPath: IndexPath) -> String {
        
        let contact = contactAtIndexPath(indexPath: indexPath)
        var phoneNumber = "(\((contact.phoneNumbers[0].value).value(forKey: "digits") as! String)"
        phoneNumber = phoneNumber.insert(string: ") ", ind: 4)
        phoneNumber = phoneNumber.insert(string: "-", ind: 9)
        return phoneNumber
        
    }
    
    func fullNameStringForContactAtIndexPath(indexPath: IndexPath) -> String {
        let contact = contactAtIndexPath(indexPath: indexPath)
        return "\(contact.givenName) \(contact.familyName)"
    }
    
}
