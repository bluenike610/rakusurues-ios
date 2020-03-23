//
//  TodoListTableViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/23.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit
import XLPagerTabStrip

@objc protocol TodoListTableViewControllerDelegate {
    func totoCompleted()
}

class TodoListTableViewController: UITableViewController
, TodoItemTableViewCellDelegate
, IndicatorInfoProvider {

    internal var itemInfo = IndicatorInfo(title: "View")
    internal var selectedIndex: Int = 0
    internal var delegate: TodoListTableViewControllerDelegate?

    let cellIdentifier = "TodoItemTableViewCell"
    private var tableData : NSMutableArray = NSMutableArray()
    private var todoItems:[Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.backgroundColor = Config.BASE
        tableView.register(UINib(nibName: "TodoItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.allowsSelection = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoItems = DatabaseManager.getTodoDatas(completed: false)
        tableView.reloadData()
    }
    
    internal func initDatas() {
        todoItems = DatabaseManager.getTodoDatas(completed: false)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemTableViewCell", for: indexPath) as! TodoItemTableViewCell
        cell.initData(todoData: todoItems[indexPath.row], ind: indexPath.row)
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func checkBtnClicked(ind: Int) {
        let selectedTodo = todoItems[ind]
        selectedTodo.completedAt = Date()
        selectedTodo.completedFlag = true
        // 上で作成したデータをデータベースに保存
        DatabaseManager.saveContext()
        initDatas()
        delegate?.totoCompleted()
    }

}
