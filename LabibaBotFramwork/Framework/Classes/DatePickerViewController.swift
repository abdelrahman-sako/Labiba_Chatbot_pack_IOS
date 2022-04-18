//
//  DatePickerViewController.swift
//  Shakawekom
//
//  Created by AhmeDroid on 4/11/17.
//  Copyright © 2017 Imagine Technologies. All rights reserved.
//

import UIKit

public protocol DatePickerViewControllerDelegate: class
{

    func datePickerController(_ datePickerVC: DatePickerViewController, didSelectDate selectedDate: Date) -> Void
    func datePickerControllerDidClearSelection(_ datePickerVC: DatePickerViewController) -> Void
}

public class DatePickerViewController: UIViewController
{

    public class func present(withDelegate delegate: DatePickerViewControllerDelegate?, mode: UIDatePicker.Mode = .dateAndTime, initialDate: Date? = nil, maximumDate: Date? = nil, userData: Any? = nil) -> Void
    {

        if let viewC = getTheMostTopViewController(),
           let datePickerVC = Labiba.storyboard.instantiateViewController(withIdentifier: "datePickerVC") as? DatePickerViewController
        {

            datePickerVC.userData = userData
            datePickerVC.selectedMode = mode
            datePickerVC.maximumDate = Date()
            datePickerVC.currentDate = initialDate ?? Date()
            datePickerVC.modalTransitionStyle = .crossDissolve
            datePickerVC.modalPresentationStyle = .overCurrentContext
            datePickerVC.delegate = delegate
            Labiba.navigationController?.present(datePickerVC, animated: true, completion: nil)
            //viewC.present(datePickerVC, animated: true, completion: {})
        }
        else
        {

            print("Can't launch date picker on non-UIViewController objects")
        }
    }

    var userData: Any?

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectionLabel: UILabel!

    var selectedMode: UIDatePicker.Mode = .date

    weak var delegate: DatePickerViewControllerDelegate?
    var maximumDate: Date?

    public override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.datePicker.maximumDate = Date()
        self.datePicker.datePickerMode = self.selectedMode

        if let _date = self.currentDate
        {
            self.updateDateLabel(_date)
            self.datePicker.setDate(_date, animated: false)
        }

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1

        self.view.addGestureRecognizer(tapRecognizer)
        tapRecognizer.addTarget(self, action: #selector(viewWasTapped))
    }

    @objc func viewWasTapped() -> Void
    {

        self.dismiss(animated: true, completion: {})
    }

    private var currentDate: Date!

    @IBAction func datePickerChanged(_ sender: Any)
    {

        let selectedDate = self.datePicker.date

        self.updateDateLabel(selectedDate)
        self.currentDate = selectedDate
    }

    func updateDateLabel(_ date: Date) -> Void
    {

        let formatter = DateFormatter()

        switch self.selectedMode
        {
        case .date:
            formatter.dateFormat = "dd/MM/YYYY"
        case .dateAndTime:
            formatter.dateFormat = "yyyy/MM/dd hh:mm a"
        case .time:
            formatter.dateFormat = "hh:mm a"
        default:
            self.selectionLabel.text = "countdown-title".local
            return
        }

        self.selectionLabel.text = formatter.string(from: date)
    }

    @IBAction func clearSelection(_ sender: Any)
    {

        self.dismiss(animated: true)
        {
            self.delegate?.datePickerControllerDidClearSelection(self)
        }
    }

    @IBAction func finishSelection(_ sender: Any)
    {

        self.dismiss(animated: true)
        {

            if self.currentDate != nil
            {
                self.delegate?.datePickerController(self, didSelectDate: self.currentDate)
            }
        }
    }
}




