//
//  DateRangeViewController.swift
//  LabibaBotClient_Example
//
//  Created by Suhayb Ahmad on 8/16/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

public struct DateRange
{
    public var SelectedDate: Date
    public var start: Date
    public var end: Date
}

public protocol DateRangeViewControllerDelegate: class
{

    func dateRangeController(_ dateRangeVC: DateRangeViewController, didSelectRange selectedRange: DateRange) -> Void
    func dateRangeControllerDidClearSelection(_ dateRangeVC: DateRangeViewController) -> Void
}

public class DateRangeViewController: UIViewController
{

    public class func present(withDelegate delegate: DateRangeViewControllerDelegate?, mode: UIDatePicker.Mode = .dateAndTime, initialDate: Date? = nil, maximumDate: Date? = nil, userData: Any? = nil) -> Void
    {

        if let viewC = getTheMostTopViewController(),
           let dateRangeVC = Labiba.storyboard.instantiateViewController(withIdentifier: "dateRangeVC") as? DateRangeViewController
        {

            dateRangeVC.userData = userData
            dateRangeVC.selectedMode = mode
            dateRangeVC.maximumDate = Date()
            dateRangeVC.modalTransitionStyle = .crossDissolve
            dateRangeVC.modalPresentationStyle = .overCurrentContext
            dateRangeVC.delegate = delegate

            viewC.present(dateRangeVC, animated: true, completion: {})
        }
        else
        {

            print("Can't launch date picker on non-UIViewController objects")
        }
    }

    var selectedMode: UIDatePicker.Mode = .date

    var maximumDate: Date?
    var userData: Any?

    weak var delegate: DateRangeViewControllerDelegate?

    public override func viewDidLoad()
    {
        super.viewDidLoad()

        self.startDatePicker.maximumDate = Date()
        self.startDatePicker.minimumDate = Date().previousYaers()

        self.SelectedDatePicker.maximumDate = Date()
        self.SelectedDatePicker.minimumDate = Date().previousYaers()

        self.endDatePicker.maximumDate = Date()
        self.endDatePicker.minimumDate = Date().previousYaers()


        self.SelectedDatePicker.isHidden = true
        self.startDatePicker.isHidden = true
        self.endDatePicker.isHidden = true
        self.clearSelectedButton.isHidden = true
        self.clearStartButton.isHidden = true
        self.clearEndButton.isHidden = true

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1

        self.view.addGestureRecognizer(tapRecognizer)
        tapRecognizer.addTarget(self, action: #selector(viewWasTapped))
    }

    @objc func viewWasTapped() -> Void
    {

        self.dismiss(animated: true, completion: {})
    }

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var clearSelectedButton: UIButton!
    @IBOutlet weak var clearEndButton: UIButton!
    @IBOutlet weak var clearStartButton: UIButton!

    @IBAction func clearDateLabel(_ sender: Any)
    {

        let button = sender as! UIButton

        UIView.animate(withDuration: 0.3)
        {

            if button.tag == 0
            {

                self.selectedDateLabel.clear()
                self.SelectedDatePicker.isHidden = true
                self.clearSelectedButton.isHidden = true

            }
            else if button.tag == 1
            {

                self.startDateLabel.clear()
                self.startDatePicker.isHidden = true
                self.clearStartButton.isHidden = true
            }
            else
            {

                self.endDateLabel.clear()
                self.endDatePicker.isHidden = true
                self.clearEndButton.isHidden = true
            }
        }
    }

    @IBOutlet weak var selectedDateLabel: DateLabel!

    @IBOutlet weak var startDateLabel: DateLabel!
    @IBOutlet weak var endDateLabel: DateLabel!

    @IBOutlet weak var SelectedDatePicker: UIDatePicker!

    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!

    @IBAction func selectSelectDate(_ sender: Any)
    {
        self.clearSelectedButton.isHidden = false
        self.selectedDateLabel.setDate(self.startDatePicker.date)

        UIView.animate(withDuration: 0.3)
        {
            self.SelectedDatePicker.isHidden = false
        }
    }

    @IBAction func selectFromDate(_ sender: Any)
    {

        self.clearStartButton.isHidden = false
        self.startDateLabel.setTime(self.startDatePicker.date)

        UIView.animate(withDuration: 0.3)
        {
            self.startDatePicker.isHidden = false
        }
    }

    @IBAction func selectToDate(_ sender: Any)
    {

        self.clearEndButton.isHidden = false
        self.endDateLabel.setTime(self.endDatePicker.date)

        UIView.animate(withDuration: 0.3)
        {
            self.endDatePicker.isHidden = false
        }
    }

    @IBAction func doneWasTapped(_ sender: Any)
    {

        if let selectDate = self.startDateLabel.currentDate, let start = self.startDateLabel.currentDate,

           let end = self.endDateLabel.currentDate
        {
            let date1 = self.startDateLabel.currentDate
            let date2 = self.endDateLabel.currentDate // 3:30

            if (date1! > date2!)
            {
                print("start bigger than end")
                showErrorMessage("validate-dates".local)
            }
            else
            {
                self.dismiss(animated: true)
                {
                    self.delegate?.dateRangeController(self, didSelectRange: DateRange(SelectedDate: selectDate, start: start, end: end))
                }
            }

//            let diff = Int((date2?.timeIntervalSince1970)! - (date1?.timeIntervalSince1970)!)
//
//            let hours = diff / 3600
//            if hours < 0 {
//                showErrorMessage( "end time should after start time".local )
//                return
//            }

        }
        else
        {

            showErrorMessage("complete-dates".local)
        }
    }

    @IBAction func datePickerChanged(_ sender: Any)
    {

        let picker = sender as! UIDatePicker

        if picker.tag == 0
        {

            self.clearSelectedButton.isHidden = false
            self.selectedDateLabel.setDate(picker.date)
            self.SelectedDatePicker.minimumDate = picker.date
            self.SelectedDatePicker.maximumDate = Date()

        }
        else if picker.tag == 1
        {

            self.clearStartButton.isHidden = false
            self.startDateLabel.setTime(picker.date)
//            self.startDatePicker.minimumDate = picker.date
            let section1 = startDatePicker.date.adding(minutes: 1)

            self.endDatePicker.minimumDate = section1
            self.endDatePicker.maximumDate = Date()

        }
        else
        {

            self.clearEndButton.isHidden = false
            self.endDateLabel.setTime(picker.date)
            let section1 = startDatePicker.date.adding(minutes: 1)

            self.endDatePicker.minimumDate = section1
            self.endDatePicker.maximumDate = Date()

        }
    }
}

class DateLabel: UILabel
{

    var currentDate: Date?

    func setDate(_ date: Date) -> Void
    {

        self.currentDate = date

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd MMMM yyyy"

        self.textColor = UIColor.darkGray
        self.text = dateFormat.string(from: date)
    }

    func setTime(_ date: Date) -> Void
    {

        self.currentDate = date

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd MMMM yyyy hh:mm a"

        self.textColor = UIColor.darkGray
        self.text = dateFormat.string(from: date)
    }

    func clear() -> Void
    {

        self.currentDate = nil
        self.textColor = UIColor.lightGray
        self.text = "select-date".local
    }
}

extension Date
{
    func adding(minutes: Int) -> Date
    {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}
