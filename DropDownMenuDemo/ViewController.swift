//
//  ViewController.swift
//  DropDownMenuDemo
//
//  Created by 石川大輔 on 2021/07/20.
//

import UIKit

var button = DropDownBtn()
var button2 = DropDownBtn()

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        button = DropDownBtn.init(frame: .init(x: 0, y: 0, width: 0, height: 0))
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        button.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        button.dropView.dorpDownOptions = ["red", "blue", "purple", "green", "pink", "gray", "yellow", "brown"]
    }


}

protocol dropDownProtocol {
    func dropDownPressed(string: String)
}



class DropDownBtn: UIButton, dropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    var dropView = DropDownView()

    var dropViewheight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        
        setTitle("Colors", for: .normal)
        dropView = DropDownView.init(frame: .init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        
    }
    
    // because those constraints below was called before the super view was able to load, so use  didMoveToSuperview() function.This is part of UIView life cycle and called after superView was called.
    override func didMoveToSuperview() {
//        this is super important part
        self.superview?.addSubview(dropView)
//            ↓↓↓ is When there are other subviews in subviews, We need this function bringSubviewToFront(), but only in this case we don't need this function actually.
        self.superview?.bringSubviewToFront(dropView)
        
        dropView.translatesAutoresizingMaskIntoConstraints = false
        
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        dropViewheight = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.dropViewheight])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.dropViewheight.constant = 150
            } else {
                self.dropViewheight.constant = self.dropView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.dropViewheight])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        } else {
            
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.dropViewheight])
            self.dropViewheight.constant = 0
            NSLayoutConstraint.activate([self.dropViewheight])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func dismissDropDown() {
        NSLayoutConstraint.deactivate([self.dropViewheight])
        self.dropViewheight.constant = 0
        NSLayoutConstraint.activate([self.dropViewheight])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dorpDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate: dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = .darkGray
        self.backgroundColor = .darkGray
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dorpDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dorpDownOptions[indexPath.row]
        cell.backgroundColor = .darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate.dropDownPressed(string: dorpDownOptions[indexPath.row])
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}


