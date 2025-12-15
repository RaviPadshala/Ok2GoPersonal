//
//  StudentDailyReportVC.swift
//  clock2go2020
//
//  Created by Mac on 17/10/24.
//

import UIKit

class StudentDailyReportVC: UIViewController {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var lbl_cordinatorName: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_projectName: UILabel!
    @IBOutlet weak var lbl_taskName: UILabel!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var tbl_sperad: UITableView!
    @IBOutlet weak var tbl_heightConstraint: NSLayoutConstraint!
    
    
    var viewModel: AccountInfoViewModel = AccountInfoViewModel(type: .allInfo)
    
    var studentReportData = DailyStudentReportsObj()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = self.readUserFromBundle(){
            self.studentReportData = data
            self.tbl_sperad.reloadData()
            self.setLocalized()
        }else{
            self.setLocalized()
        }
        
        self.setupTableview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? addReachabilityObserver()
//        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        self.tbl_sperad.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        removeReachabilityObserver()
        self.tbl_sperad.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                self.tbl_heightConstraint.constant = newsize.height
            }
        }
    }

    func setLocalized() {
        self.lbl_title.text = "DAILY_STUDENT_REPORTS_TITLE".localized
        self.lbl_cordinatorName.text = "HELLO".localized + "Ravi P."
        self.lbl_date.text = self.viewModel.getCurrentDateString(formate: "dd/mm/yyyy")
        self.lbl_projectName.text = self.studentReportData.ProjectName ?? "-"
        self.lbl_taskName.text = self.studentReportData.TaskName ?? "-"
        self.btn_confirm.setTitle("CONFIRMATION_TITLE".localized, for: .normal)
        self.btn_confirm.border(width: 2.0, color: UIColor(named: "Color104876")!.cgColor)
    }
    
    func readUserFromBundle() -> DailyStudentReportsObj? {
        
        if let url = Bundle.main.url(forResource: "dailyStudentReports", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(DailyStudentReportsObj.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    //MARK: - Button Action
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        _ = NavigationController.shared?.popViewController(animated: false)
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        
//        let completionReport = UpdateDailyStudentReportEndpoint(obj: self.studentReportData)
//        completionReport.apiCall { [weak self] (result, error) in
////            self?.clearLastEntryData()
////            completion()
//        }
        
    }
    
    @objc func clickYes(sender: UIButton){
        if let arr = self.studentReportData.studentsdata, arr.count > 0{
            self.studentReportData.studentsdata?[sender.tag].presenceConfirmation = 1
            self.tbl_sperad.reloadRows(at: [IndexPath(row: sender.tag + 1, section: 0)], with: .none)
        }
    }
    
    @objc func clickNo(sender: UIButton){
        if let arr = self.studentReportData.studentsdata, arr.count > 0{
            self.studentReportData.studentsdata?[sender.tag].presenceConfirmation = 0
            self.tbl_sperad.reloadRows(at: [IndexPath(row: sender.tag + 1, section: 0)], with: .none)
        }
    }
    
    @objc func clickRed(sender: UIButton){
        if let arr = self.studentReportData.studentsdata, arr.count > 0{
            self.studentReportData.studentsdata?[sender.tag].scoreRYG?.R = 1
            self.studentReportData.studentsdata?[sender.tag].scoreRYG?.Y = 0
            self.studentReportData.studentsdata?[sender.tag].scoreRYG?.G = 0
            self.tbl_sperad.reloadRows(at: [IndexPath(row: sender.tag + 1, section: 0)], with: .none)
        }
    }
    
    @objc func clickYellow(sender: UIButton){
        if let arr = self.studentReportData.studentsdata, arr.count > 0{
            self.studentReportData.studentsdata?[sender.tag].scoreRYG?.R = 0
            self.studentReportData.studentsdata?[sender.tag].scoreRYG?.Y = 1
            self.studentReportData.studentsdata?[sender.tag].scoreRYG?.G = 0
            self.tbl_sperad.reloadRows(at: [IndexPath(row: sender.tag + 1, section: 0)], with: .none)
        }
    }
    
    @objc func clickGreen(sender: UIButton){
        if let arr = self.studentReportData.studentsdata, arr.count > 0{
            self.studentReportData.studentsdata?[sender.tag].scoreRYG?.R = 0
            self.studentReportData.studentsdata?[sender.tag].scoreRYG?.Y = 0
            self.studentReportData.studentsdata?[sender.tag].scoreRYG?.G = 1
            self.tbl_sperad.reloadRows(at: [IndexPath(row: sender.tag + 1, section: 0)], with: .none)
        }
    }
}

extension StudentDailyReportVC: ReachabilityObserverDelegate {

    // MARK: Reachability

    func reachabilityChanged(_ isReachable: Bool) {
        ReachabilityManager.shared.hasInternetConnection = isReachable

        if !isReachable {
            print("No internet connection")
        } else {
            print("Has Internet connection")
        }
    }

}

extension StudentDailyReportVC: UITableViewDataSource, UITableViewDelegate{
    
    func setupTableview(){
        
        self.tbl_sperad.dataSource = self
        self.tbl_sperad.delegate = self
        
        let nibCell = UINib(nibName: "SDR_HeaderCell", bundle: nil)
        self.tbl_sperad.register(nibCell, forCellReuseIdentifier: "SDR_HeaderCell")
        
        let nibCell1 = UINib(nibName: "SDR_DataCell", bundle: nil)
        self.tbl_sperad.register(nibCell1, forCellReuseIdentifier: "SDR_DataCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = self.studentReportData.studentsdata, arr.count > 0{
            return arr.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SDR_HeaderCell", for: indexPath) as! SDR_HeaderCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SDR_DataCell", for: indexPath) as! SDR_DataCell
            if let arr = self.studentReportData.studentsdata, arr.count > 0{
                let dict = arr[indexPath.row - 1]
                
                cell.lbl_studentName.text = "-"
                
                if let str = dict.studentname, str.count > 0{
                    cell.lbl_studentName.text = str
                }
                
                cell.img_yes.image = UIImage(named: "radio_unselect")
                cell.img_yes.image = UIImage(named: "radio_unselect")
                if let present = dict.presenceConfirmation, present == 1{
                    cell.img_yes.image = UIImage(named: "radio_select")
                }else{
                    cell.img_no.image = UIImage(named: "radio_select")
                }
                
                cell.img_green.border(width: 0, color: UIColor.clear.cgColor)
                cell.img_yellow.border(width: 0, color: UIColor.clear.cgColor)
                cell.img_red.border(width: 0, color: UIColor.clear.cgColor)
                if let srg = dict.scoreRYG{
                    if let r = srg.R, r == 1{
                        cell.img_red.border(width: 1.5, color: UIColor.black.cgColor)
                    }
                    
                    if let y = srg.Y, y == 1{
                        cell.img_yellow.border(width: 1.5, color: UIColor.black.cgColor)
                    }
                    
                    if let g = srg.G, g == 1{
                        cell.img_green.border(width: 1.5, color: UIColor.black.cgColor)
                    }
                }
                
                if let str = dict.comment, str.count > 0{
                    cell.txt_notes.text = str
                }
                
                cell.btn_entryTime.setTitle("--:--", for: .normal)
                if let str = dict.trnsTime, str.count > 0{
                    let time = str.changeDateFormat(from: "yyyy-MM-dd HH:mm:ss", to: "HH:mm")
                    cell.btn_entryTime.setTitle(time, for: .normal)
                }
                
            }
            cell.lbl_number.text = "\(indexPath.row)"
            
            cell.btn_no.tag = indexPath.row - 1
            cell.btn_no.addTarget(self, action: #selector(self.clickNo), for: .touchUpInside)
            
            cell.btn_yes.tag = indexPath.row - 1
            cell.btn_yes.addTarget(self, action: #selector(self.clickYes), for: .touchUpInside)
            
            cell.btn_red.tag = indexPath.row - 1
            cell.btn_red.addTarget(self, action: #selector(self.clickRed), for: .touchUpInside)
            
            cell.btn_yellow.tag = indexPath.row - 1
            cell.btn_yellow.addTarget(self, action: #selector(self.clickYellow), for: .touchUpInside)
            
            cell.btn_green.tag = indexPath.row - 1
            cell.btn_green.addTarget(self, action: #selector(self.clickGreen), for: .touchUpInside)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 50
        }else{
            return UITableView.automaticDimension
        }
    }
}
