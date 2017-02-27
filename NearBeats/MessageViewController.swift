//
//  MessageViewController.swift
//  NearBeats
//
//  Created by Xie kesong on 2/23/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse

fileprivate let reuseIden = "MessageCell"
class MessageViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.estimatedRowHeight = self.tableView.rowHeight
            self.tableView.rowHeight = UITableViewAutomaticDimension
        }
    }

    @IBOutlet weak var footerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var sendBtn: UIButton!{
        didSet{
            self.sendBtn.layer.cornerRadius = 3.0
            self.sendBtn.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var messageTextField: UITextField!{
        didSet{
            self.messageTextField.delegate = self
        }
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        guard let text = self.messageTextField.text, !text.isEmpty else{
            return
        }
       PFUser.current()?.sendMessage(text: text, completion: { (message, error) in
            Message.fetchMessages { (messages, error) in
                if let messages = messages{
                    self.messageTextField.text = ""
                    self.messages = messages
                }else{
                    print("message not send")
                }
            }
        })
        
    }
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    var isFetching: Bool = false
    
    var messages: [Message]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var footerViewInitialOriginY: CGFloat = 0

    
    lazy var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: Notification.Name("UIKeyboardDidShowNotification"), object: nil)
        self.fetchMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.footerViewInitialOriginY = self.footerView.frame.origin.y
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    func fetchMessages(){
        if !self.isFetching{
            self.isFetching = true
            Message.fetchMessages { (messages, error) in
                if let messages = messages{
                    self.isFetching = false
                    self.messages = messages
                }
            }
        }
    }

    func timerCallBack(){
       self.fetchMessages()
    }
    
    
    func keyboardDidShow(notification: Notification){
        if let keyboardRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            let keyboardHeight = keyboardRect.height
            UIView.animate(withDuration: 0.3, animations: {
                self.footerView.frame.origin.y = self.footerViewInitialOriginY - keyboardHeight
                self.footerBottomConstraint.constant = keyboardHeight
            })
        }
    }
    

    
  
}
extension MessageViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! MessageTableViewCell
        cell.message = self.messages![indexPath.row]
        return cell
    }
}

extension MessageViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
