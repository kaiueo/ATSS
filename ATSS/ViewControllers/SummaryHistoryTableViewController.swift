//
//  SummaryHistoryTableViewController.swift
//  ATSS
//
//  Created by 张克 on 08/02/2018.
//  Copyright © 2018 zhangke. All rights reserved.
//

import UIKit

class SummaryHistoryTableViewController: UITableViewController {

    @IBAction func emptyButtonDIdTouch(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: UserDefaultsStrings.RecentSummary)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl?.attributedTitle = NSAttributedString(string: "刷新")
    }
    
    @objc func refreshData(){
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let recent = UserDefaults.standard.object(forKey: UserDefaultsStrings.RecentSummary)
        if recent==nil {
            return 0
        }else{
            let recentSummary = recent as! [[String: [String:[String]]]]
            return recentSummary.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: StoryBoardConfigs.SummaryHistoryTableViewCellIdentifier)
        let recent = UserDefaults.standard.object(forKey: UserDefaultsStrings.RecentSummary)
        if recent != nil {
            let recentSummary = recent as! [[String: [String:[String]]]]
            cell.textLabel?.text = recentSummary[indexPath.row].values.first?.keys.first?.trimmingCharacters(in: .newlines)
            print(cell.textLabel?.text)
            cell.detailTextLabel?.text = recentSummary[indexPath.row].keys.first
        }else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: StoryBoardConfigs.HistoryToSummarySegue, sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == StoryBoardConfigs.HistoryToSummarySegue {
            let toView = segue.destination as! SummarizationViewController
            let recent = UserDefaults.standard.object(forKey: UserDefaultsStrings.RecentSummary)
            let recentSummary = recent as! [[String: [String:[String]]]]
            let summarizedArticle = SummarizedArticle()
            let indexPath = sender as! IndexPath
            summarizedArticle.article = recentSummary[indexPath.row].values.first?.keys.first
            summarizedArticle.summary = recentSummary[indexPath.row].values.first?.values.first
            toView.summarizedArticle = summarizedArticle
            
        }
        
    }
    

}
