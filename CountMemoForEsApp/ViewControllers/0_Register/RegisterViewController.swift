//
//  RegisterViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/20.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController
, UIPickerViewDelegate
, UIPickerViewDataSource
, UITableViewDelegate
, UITableViewDataSource
, UIImagePickerControllerDelegate
, UINavigationControllerDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewCell: UITableViewCell!
    @IBOutlet weak var avataImg: UIImageView!
    
    @IBOutlet weak var memoTypeLe: UITextField!
    
    @IBOutlet weak var userNameLe: UITextField!
    
    @IBOutlet weak var emailLe: UITextField!
    
    @IBOutlet weak var passwordLe1: UITextField!
    
    @IBOutlet weak var passwordLe2: UITextField!

    private var selectedTypeIndex: Int = 0
    private var userImg: UIImage!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.alwaysBounceVertical = false
        
        self.avataImg.layer.cornerRadius = 10

        userImg = nil

        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.userNameLe.inputAccessoryView = doneToolbar
        self.emailLe.inputAccessoryView = doneToolbar
        self.passwordLe1.inputAccessoryView = doneToolbar
        self.passwordLe2.inputAccessoryView = doneToolbar
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.tableView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInset
    }
    
    @objc func doneButtonAction(){
        self.userNameLe.resignFirstResponder()
        self.emailLe.resignFirstResponder()
        self.passwordLe1.resignFirstResponder()
        self.passwordLe2.resignFirstResponder()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCell
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCALE(value: 600)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Config.MemoTypeData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Config.MemoTypeData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTypeIndex = row
        memoTypeLe.text = Config.MemoTypeData[row]
    }

    func checkEmptyFeild() -> Bool {
        
        if self.memoTypeLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "Memo Type"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.emailLe.text == "" || !(self.emailLe.text?.contains("@"))! {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "メールアドレス"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.userNameLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "アカウント名"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.passwordLe1.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "パスワード"+Config.INPUT_ERR_MSG)
            return false
        }else {
            if self.passwordLe2.text == "" {
                Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "パスワード（確認）"+Config.INPUT_ERR_MSG)
                return false
            }else {
                if self.passwordLe1.text != self.passwordLe2.text {
                    Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "パスワードが一致しません。")
                    return false
                }
            }
        }
        
        return true
    }

    @IBAction func memoTypeBtnClicked(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: Config.SCREEN_WIDTH,height: 150)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: Config.SCREEN_WIDTH, height: 150))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(selectedTypeIndex, inComponent: 0, animated: false)
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "MemoTypeを選択してください。", message: nil, preferredStyle: .actionSheet)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            editRadiusAlert.dismiss(animated: true, completion: nil)
        }))
        present(editRadiusAlert, animated: true, completion: nil)
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        if checkEmptyFeild() {
            let userInfo = UserModel()
            userInfo.memoType = selectedTypeIndex
            userInfo.userName = userNameLe.text!
            if userImg != nil {
                Common.saveImage(imageName: "avata.png", image: userImg)
                userInfo.avata = "avata.png"
            }else {
                userInfo.avata = ""
            }
            userInfo.email = emailLe.text!
            userInfo.password = passwordLe1.text!
            
            LocalstorageManager.setLoginInfo(info: userInfo)
            Common.me = userInfo
            
            self.dismiss(animated: true) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let delegateObj = AppDelegate.instance();
                DispatchQueue.main.async {
                            let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "mainView") as UIViewController
                            vc.modalPresentationStyle = .fullScreen
                            delegateObj.window?.rootViewController!.present(vc, animated: true, completion: {
                            })
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.avataImg.image = image
        self.userImg = image
    }

    
    @IBAction func avataBtnClicked(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "画像の選択",
                                                         message: "",
                                                         preferredStyle: .actionSheet);
        let registerAction: UIAlertAction = UIAlertAction(title: "写真を撮影", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        })
        let loginAction: UIAlertAction = UIAlertAction(title: "アルバムから選択", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル",
                                                        style: .cancel,
                                                        handler: nil)
        alert.addAction(registerAction)
        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}
