//
//  CreateCardViewController.swift
//  clock2go2020
//
//  Created by Mac on 29/08/24.
//

import UIKit
import PassKit

class CreateCardViewController: UIViewController {
    override func viewDidLoad() {
            super.viewDidLoad()

            // Call this function to download and add the pass to Wallet
            downloadAndAddPass()
        }

        func downloadAndAddPass() {
            guard let passURL = URL(string: "https://d.pslot.io/p/FLJ0QMrYTs2ss9nSlT3LQg?t=Fy7Wty4") else {
                print("Invalid URL")
                return
            }

            let session = URLSession(configuration: .default)
            let downloadTask = session.dataTask(with: passURL) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Failed to download pass: \(error?.localizedDescription ?? "No error description")")
                    return
                }

                do {
                    let pass = try PKPass(data: data)
                    let passLibrary = PKPassLibrary()

                    if passLibrary.containsPass(pass) {
                        print("Pass already exists in Wallet")
                    } else {
                        DispatchQueue.main.async {
                            self.addPassToWallet(pass)
                        }
                    }
                } catch {
                    print("Failed to create pass: \(error.localizedDescription)")
                }
            }

            downloadTask.resume()
        }

        func addPassToWallet(_ pass: PKPass) {
            let addPassesViewController = PKAddPassesViewController(pass: pass)
            self.present(addPassesViewController!, animated: true, completion: nil)
        }
    }
