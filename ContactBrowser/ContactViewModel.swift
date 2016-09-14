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
        print(contactModel.contacts)
    }
    
    func loadFilteredContacts(filterString: String) {
        let toFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: toFetch as [CNKeyDescriptor])
        
        do {
            try store.enumerateContacts(with: request) {
                contact, stop in
                if contact.givenName.hasPrefix(filterString) || ((contact.phoneNumbers[0].value).value(forKey: "digits") as! String).hasPrefix(filterString) {
                    if contact.phoneNumbers.description != "" {         // Prevents adding the contact if there is no phone number
                        if self.contactModel.filteredContacts[String(contact.givenName.characters.first!)] == nil {
                            self.contactModel.filteredContacts[String(contact.givenName.characters.first!)] = [CNContact]()
                        }
                        
                        self.contactModel.filteredContacts[String(contact.givenName.characters.first!)]!.append(contact)
                    }
                }
            }
        } catch let err {
            print(err)
        }
    }
    
    func resetFilteredContactArray() {
        contactModel.filteredContacts.removeAll()
    }
    
}
