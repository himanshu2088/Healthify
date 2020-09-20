//
//  ChatVC.swift
//  Healthify
//
//  Created by Himanshu Joshi on 06/09/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var messageArray = [Message]()
    var messageDictionary = [String : Message]()

    let cellId = "cellId"

    let newChatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "new_message.png"), for: .normal)
        return button
    }()

    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    let profileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 18.0)
        label.textColor = .black
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        tableView.allowsSelection = true
        tableView.backgroundColor = .white
        tableView.rowHeight = 70.0
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserAndNavBarTitle()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine

        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 61.0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true

    }

    func fetchUserAndNavBarTitle() {

            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }

            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject] {

                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }

            }, withCancel: nil)

        }

        func setupNavBarWithUser(_ user: User) {

            messageArray.removeAll()
            messageDictionary.removeAll()
            tableView.reloadData()

            observeUserMessages()

            self.view.addSubview(self.lineView)
            self.lineView.translatesAutoresizingMaskIntoConstraints = false
            self.lineView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60.0).isActive = true
            self.lineView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            self.lineView.heightAnchor.constraint(equalToConstant: 0.7).isActive = true

            self.view.addSubview(self.profileLabel)
            self.profileLabel.text = user.name
            self.profileLabel.translatesAutoresizingMaskIntoConstraints = false
            self.profileLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
            self.profileLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true

            self.view.addSubview(newChatButton)
            self.newChatButton.translatesAutoresizingMaskIntoConstraints = false
            self.newChatButton.isUserInteractionEnabled = true
            self.newChatButton.centerYAnchor.constraint(equalTo: self.profileLabel.centerYAnchor, constant: 0.0).isActive = true
            self.newChatButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
            self.newChatButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            self.newChatButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            self.newChatButton.addTarget(self, action: #selector(toNewChatVC(_:)), for: .touchUpInside)

        }

    @objc func toNewChatVC(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AllChatsVC") as? AllChatsVC
        present(viewController!, animated: true, completion: nil)
    }

    func observeUserMessages() {

        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)

            messageRef.observeSingleEvent(of: .value, with: { (snap) in

                if let dictionary = snap.value as? [String: AnyObject] {
                    let message = Message(dictionary: dictionary)

                    if let chatPartnerId = message.chatPartnerId() {
                        self.messageDictionary[chatPartnerId] = message

                        self.messageArray = Array(self.messageDictionary.values)
                        self.messageArray.sorted { (message1, message2) -> Bool in
                            return Int(message1.timestamp!) > Int(message2.timestamp!)
                        }
                    }

                    self.timer?.invalidate()
                    print("we just canceled our timer")

                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    print("schedule a table reload in 0.1 sec")

                }


            }, withCancel: nil)

        }, withCancel: nil)

    }

    var timer: Timer?

    @objc func handleReloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func showChatControllerForUser(user: User) {
        let particularChatVC = ParticularChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        particularChatVC.user = user
        present(particularChatVC, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messageArray[indexPath.row]
        cell.message = message
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messageArray[indexPath.row]

        guard let chatPartnerId = message.chatPartnerId() else{ return }

        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }


            let user = User(dictionary: dictionary)
            user.id = chatPartnerId

            self.showChatControllerForUser(user: user)


        }, withCancel: nil)

    }

}

