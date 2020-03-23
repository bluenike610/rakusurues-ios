//
//  AddTodoViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/23.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController
, UITableViewDelegate
, UITableViewDataSource
, UITextViewDelegate
, WWCalendarTimeSelectorProtocol{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewCell: UITableViewCell!
    
    @IBOutlet weak var taskNameLe: ScaleTextField!
    
    @IBOutlet weak var taskDetailTxt: ScaledTextView!
    @IBOutlet weak var timeLe: ScaleTextField!
    
    @IBOutlet weak var colorBtn1: UIButton!
    @IBOutlet weak var colorBtn2: UIButton!
    @IBOutlet weak var colorBtn3: UIButton!
    @IBOutlet weak var colorBtn4: UIButton!
    @IBOutlet weak var colorBtn5: UIButton!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var currentNumLb: ScaledLabel!
    
    //UIDatePickerを定義するための変数
    var datePicker: UIDatePicker = UIDatePicker()
    //resultDateで１日前を日付計算
    var resultDate:Date?
    var selectedColorIndex: Int = 0
    var preContentTxt:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        Common.setBorderColor(view: self.taskDetailTxt)
        self.colorBtn1.layer.cornerRadius = 10
        self.colorBtn2.layer.cornerRadius = 10
        self.colorBtn3.layer.cornerRadius = 10
        self.colorBtn4.layer.cornerRadius = 10
        self.colorBtn5.layer.cornerRadius = 10

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.alwaysBounceVertical = false
        
        setUI(colorBtn1)
//        // ピッカー設定
//        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
//        datePicker.timeZone = NSTimeZone.local
//        datePicker.locale = Locale(identifier: "ja")
//        timeLe.inputView = datePicker
        
        self.taskDetailTxt.delegate = self

//        // 決定バーの生成
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
//        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtn))
//        toolbar.setItems([spacelItem, doneItem], animated: true)
//        
//        // インプットビュー設定(紐づいているUITextfieldへ代入)
//        timeLe.inputView = datePicker
//        timeLe.inputAccessoryView = toolbar

        self.taskNameLe.becomeFirstResponder()

        addDoneButtonOnKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
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

        self.taskNameLe.inputAccessoryView = doneToolbar
        self.taskDetailTxt.inputAccessoryView = doneToolbar
    }

    /*
     ピッカーのdoneボタン
    */

        // UIDatePickerのDoneを押したら発火
        @objc func doneBtn() {
            self.timeLe.resignFirstResponder()

            // 日付のフォーマット
            let formatter = DateFormatter()
            //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できる
            formatter.dateFormat = "yyyy年MM月dd日HH時"
            //datePickerで指定した日付が表示される
            timeLe.text = "\(formatter.string(from: datePicker.date))"
            let pickerTime = datePicker.date

            print(pickerTime)
            //前日,日本時間を設定
            resultDate = Common.calcDate(baseDate: pickerTime)
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
        self.taskNameLe.resignFirstResponder()
        self.taskDetailTxt.resignFirstResponder()
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
     return SCALE(value: 550)
    }

    //入力ごとに文字数をカウントする
    func textViewDidChange(_ textView: UITextView) {
        let str = taskDetailTxt.text
        let commentNum = taskDetailTxt.text.count
        //空白と改行を抽出して取り除く
        let newStr = String(str!.unicodeScalars
            .filter(CharacterSet.whitespacesAndNewlines.contains)
            .map(Character.init))
        let numLabel = commentNum - newStr.count
        if numLabel > 200 {
            self.taskDetailTxt.text = preContentTxt
            return
        }
        currentNumLb.text = String(numLabel)
        preContentTxt = taskDetailTxt.text
    }
    
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []

    func showCalendarSelecter() {
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates)
        selector.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)

        present(selector, animated: true, completion: nil)
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print("Selected \n\(date)\n---")
        singleDate = date
        // 日付のフォーマット
        let formatter = DateFormatter()
        //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できる
        formatter.dateFormat = "yyyy年MM月dd日HH時"
        //datePickerで指定した日付が表示される
        timeLe.text = "\(formatter.string(from: date))"
        let pickerTime = date

        print(pickerTime)
        //前日,日本時間を設定
        resultDate = Common.calcDate(baseDate: pickerTime)
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        print("Selected Multiple Dates \n\(dates)\n---")
        if let date = dates.first {
            singleDate = date
        }
        else {
        }
        multipleDates = dates
    }

    func checkEmptyFeild() -> Bool {
        
        if self.taskNameLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "タスク名"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.taskDetailTxt.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "タスク詳細"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.timeLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "タスク期限"+Config.INPUT_ERR_MSG)
            return false
        }
        
        return true
    }

    func setUI(_ view: UIButton) {
        let selectedColor = UIColor.systemBlue
        colorBtn1.layer.borderWidth = 0
        colorBtn2.layer.borderWidth = 0
        colorBtn3.layer.borderWidth = 0
        colorBtn4.layer.borderWidth = 0
        colorBtn5.layer.borderWidth = 0

        view.layer.borderWidth = 2
        view.layer.borderColor = selectedColor.cgColor
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        if checkEmptyFeild() {
            let todo:Todo = Todo(context: DatabaseManager.persistentContainer.viewContext)
            todo.name = taskNameLe.text
            todo.desc = taskDetailTxt.text
            todo.bgColor = Config.TodoColors[selectedColorIndex]
            todo.alertFlag = notificationSwitch.isOn
            todo.completedFlag = false
            todo.alertTime = resultDate
            todo.createdAt = Date()
            todo.completedAt = Date()

            // 上で作成したデータをデータベースに保存
            DatabaseManager.saveContext()
            if todo.alertFlag {
                let timeInterval = resultDate?.timeIntervalSince(Common.calcDate(baseDate: Date()))
                if timeInterval != nil {
                    LocalNotificationManager.addNotificaion(title: todo.name!, id: todo.name!+todo.bgColor!, time: timeInterval!)
                }
            }
            //入力値をクリアにする
            taskNameLe.text = ""
            taskDetailTxt.text = ""
            timeLe.text = ""

            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func colorBtn1Clicked(_ sender: Any) {
        selectedColorIndex = 0
        setUI(colorBtn1)
    }
    @IBAction func colorBtn2Clicked(_ sender: Any) {
        selectedColorIndex = 1
        setUI(colorBtn2)
    }
    @IBAction func colorBtn3Clicked(_ sender: Any) {
        selectedColorIndex = 2
        setUI(colorBtn3)
    }
    @IBAction func colorBtn4Clicked(_ sender: Any) {
        selectedColorIndex = 3
        setUI(colorBtn4)
    }
    @IBAction func colorBtn5Clicked(_ sender: Any) {
        selectedColorIndex = 4
        setUI(colorBtn5)
    }
    
    @IBAction func timeBtnClicked(_ sender: Any) {
        showCalendarSelecter()
    }

}
