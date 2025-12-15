//
//  SupportViewController.swift
//  clock2go2020
//
//  Created by Admin on 4/8/20.
//

import UIKit

class SupportViewController: UIViewController {

    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var representativeLabel: UILabel!
    @IBOutlet weak var hereButton: UIButton!
    // MARK: Override
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       setLocalized()
    }

    func setLocalized() {
        screenTitle.text = "SUPPORT_TITLE".localized
        textView.text = "SUPPORT_TEXT".localized
        hereButton.setTitle("here".localized, for: .normal)
        representativeLabel.text = "to_contact_us_click".localized
        let supportString = "SUPPORT_GUIDE_TEXT".localized
        let clickHereString = "SUPPORT_CLICK_HERE".localized

        guideLabel.attributedText = supportString.getUnderlined(color: #colorLiteral(red: 0.271813333, green: 0.5785918832, blue: 0.971803844, alpha: 1), stringForUnderline: clickHereString)
        guideLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:))))
    }

    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let text = "SUPPORT_GUIDE_TEXT".localized
        let termsRange = (text as NSString).range(of: "SUPPORT_CLICK_HERE".localized)

        if gesture.didTapAttributedTextInLabel(label: guideLabel, inRange: termsRange) {
            showGuideView()
        }
    }

    func showGuideView() {
        let vc = ViewSource.guideVideoView()
        vc.shouldPushToDashboard = false
        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    @IBAction func backAction(_ sender: Any) {
        dismissView()
    }

    @IBAction func WhatsAppGuideAction(_ sender: UIButton) {
        whatsAppSupport()
    }

    func dismissView() {
        _ = NavigationController.shared?.popViewController(animated: true)
    }

    func whatsAppSupport() {
        let webURL = "https://wa.me/972506801061?text=שלום, אשמח לקבל עזרה באתר"
        if let urlString = webURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
                } else {
                    print("error")
                }
            }
        }
    }
}
