//
//  ContactBrowserTableViewController.swift
//  ContactBrowser
//
//  Created by Nolan Lapham on 9/12/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import UIKit
import Contacts

class ContactBrowserTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    // MARK: - Outlets, Models and Variables
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contactViewModel = ContactViewModel()
    
    private let contactBrowserCellIdentifier = "ContactTableViewCell"
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
            self?.contactViewModel.loadContacts()
            DispatchQueue.main.async { () -> Void in
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText != "" {
            contactViewModel.shouldShowSearchResults = true
            contactViewModel.resetFilteredContactArray()
            DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
                self?.contactViewModel.loadFilteredContacts(filterString: searchText)
                DispatchQueue.main.async { () -> Void in
                    self?.tableView.reloadData()
                }
            }
        } else {
            contactViewModel.shouldShowSearchResults = false
            self.tableView.reloadData()
        }
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        var sections = 0
        
        if (contactViewModel.shouldShowSearchResults) {
            for _ in contactViewModel.contactModel.filteredContacts.keys {
                sections += 1
            }
        } else {
            for _ in contactViewModel.contactModel.contacts.keys {
                sections += 1
            }
        }
        
        return sections
        
    }
        
    let Alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows = 0
        
        if (contactViewModel.shouldShowSearchResults) {
            if let contact = contactViewModel.contactModel.filteredContacts[Alphabet[section]] {
                rows = contact.count
            }
        } else {
            if let contact = contactViewModel.contactModel.contacts[Alphabet[section]] {
                rows = contact.count
            }
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return Alphabet[section]
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: contactBrowserCellIdentifier, for: indexPath) as UITableViewCell
        
        var contact = CNContact()
        
        if (contactViewModel.shouldShowSearchResults) {
            contact = (contactViewModel.contactModel.filteredContacts[Alphabet[indexPath.section]]?[indexPath.row])!
        } else {
            contact = (contactViewModel.contactModel.contacts[Alphabet[indexPath.section]]?[indexPath.row])!
        }
        
        cell.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        var phoneNumber = "(\((contact.phoneNumbers[0].value).value(forKey: "digits") as! String)"
        phoneNumber = phoneNumber.insert(string: ") ", ind: 4)
        phoneNumber = phoneNumber.insert(string: "-", ind: 9)
        cell.detailTextLabel?.text = "\(phoneNumber)"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var contact = CNContact()
        
        if (contactViewModel.shouldShowSearchResults) {
            contact = (contactViewModel.contactModel.filteredContacts[Alphabet[indexPath.section]]?[indexPath.row])!
        } else {
            contact = (contactViewModel.contactModel.contacts[Alphabet[indexPath.section]]?[indexPath.row])!
        }
        
        let contactName = "\(contact.givenName) \(contact.familyName)"
        var phoneNumber = "(\((contact.phoneNumbers[0].value).value(forKey: "digits") as! String)"
        phoneNumber = phoneNumber.insert(string: ") ", ind: 4)
        phoneNumber = phoneNumber.insert(string: "-", ind: 9)
        
        let alertController = UIAlertController(title: "Call Contact", message: "Would you like to call \(contactName) at number: \(phoneNumber)?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            let phoneNumberForCalling = (contact.phoneNumbers[0].value).value(forKey: "digits") as! String
            if let url = NSURL(string: "tel://\(phoneNumberForCalling)") {
                UIApplication.shared.open(URL(string: "\(url)")!, options: [:]) { completion in print("Was number \(phoneNumberForCalling) called? \(completion)") }
            }
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
        
    }
    
}

    // MARK: - Extensions to Fundamental Classes

extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
    
}
