//
//  EntryDisplay.swift
//  Visit Jordan Bot
//
//  Created by AhmeDroid on 10/29/16.
//  Copyright © 2016 Imagine Technologies. All rights reserved.
//

import UIKit
import CoreLocation
//import Alamofire

protocol EntryDisplayTarget
{

    var botConnector: BotConnector
    {
        get
    }
    func reloadView(display: EntryDisplay)
    func renderStep(step: ConversationDialog, wait: Double) -> Void
}

protocol EntryDisplayDelegate
{

    func displayActionResponseForDialog(_ dialog: ConversationDialog) -> Void
    func failLoadingActionResponseForDialog(_ dialog: ConversationDialog, error: Error?) -> Void
}

protocol ReusableComponent: class
{
    
    static var reuseId: String
    {
        get
    }
     var created: Bool
    {
        get
    }
    static func create<T: UIView & ReusableComponent>(frame: CGRect) -> T
}

enum LoadingStatus
{
    case success
    case failed
    case loading
}

typealias EntryProcessCompletionBlock = () -> Void

class EntryDisplay: Equatable
{

    var loadingStatus: LoadingStatus = .success
    var content_type: String?

    static func ==(lhs: EntryDisplay, rhs: EntryDisplay) -> Bool
    {
        return lhs.id == rhs.id
    }

    private var _components = [String: ReusableComponent]()

    func dequeueReusableComponent<T: UIView & ReusableComponent>(frame: CGRect) -> T
    {

        if let view = _components[T.reuseId] as? T
        {

            view.frame = frame
            return view

        }
        else
        {

            let view: T = T.create(frame: frame)
            self._components[T.reuseId] = view
            return view
        }
    }

    var dialog: ConversationDialog

    var nextEntryId: String?
    var actionResponse: Data?

    var target: EntryDisplayTarget?
    var isBubbleShown: Bool = false

    var id: String = UUID().uuidString

    init(dialog: ConversationDialog)
    {
        self.dialog = dialog
        self.isBubbleShown = false
    }

    var height: CGFloat = 40
    var status: EntryDisplayStatus = .NotShown
    var delegate: EntryDisplayDelegate?

    var isActionAttempted: Bool = false
    private var _loadingTask: DataRequest?

    func remove() -> Void
    {
        self.target = nil
        self.delegate = nil
        self._loadingTask?.cancel()
    }

    func performConversationMediaAction() -> Void
    {

        if let media = self.dialog.media
        {

            self.isActionAttempted = true
            self.actionResponse = nil

            if let url = media.url
            {

                print("Calling \(media.type) media: \(url)")

                if media.type == .Photo
                {

                    self.isGifPhoto = url.lowercased()
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .hasSuffix(".gif")

                    self._loadingTask = request(url).responseData(completionHandler: { (response) in

                        if let error = response.result.error
                        {

                            print("Error executing conversation action: \(error.localizedDescription)")
                            self.delegate?.failLoadingActionResponseForDialog(self.dialog, error: error)

                        }
                        else if let data = response.result.value
                        {

                            let dialog = self.dialog
                            self.actionResponse = data

                            if self.parseActionResponseAsPhoto() != nil
                            {

                                self.delegate?.displayActionResponseForDialog(dialog)
                            }
                            else
                            {

                                self.actionResponse = nil
                                self.delegate?.failLoadingActionResponseForDialog(dialog, error: nil)
                            }

                        }
                        else
                        {

                            print("No valid response for media action request ...")
                            self.delegate?.failLoadingActionResponseForDialog(self.dialog, error: nil)
                        }
                    })

                }
                else
                {

                    self.delegate?.displayActionResponseForDialog(dialog)
                }

            }
            else
            {

                self.delegate?.failLoadingActionResponseForDialog(self.dialog, error: nil)
            }
        }

    }


    private var isGifPhoto: Bool = false
    private var _photo: UIImage?

    func parseActionResponseAsPhoto() -> UIImage?
    {

        if _photo == nil
        {

            if let responseData = self.actionResponse
            {

                _photo = self.isGifPhoto ? UIImage.animatedImage(withAnimatedGIFData: responseData) : UIImage(data: responseData)
            }
        }

        return _photo
    }

    func reload() -> Void
    {

        self.target?.reloadView(display: self)
    }
}

enum EntryDisplayStatus: String
{

    case NotShown = "notShownCell"
    case OnHold = "onHoldCell"
    case Shown = "shownCell"
    case guide = "UsageGuideCell"
}

class ProcessedChoice
{
    var title: String

    init(title: String)
    {
        self.title = title
    }
}


class EmotionInfo
{

    var status: String

    init(status: String)
    {
        self.status = status
    }
}

public enum GenericActivityFormat: Int
{

    case event = 0
    case attraction = 1
    case resturant = 2
    case hotel = 3

    static func format(forIndex index: Int) -> GenericActivityFormat
    {

        switch index
        {
        case 0:
            return GenericActivityFormat.event
        case 1:
            return GenericActivityFormat.attraction
        case 2:
            return GenericActivityFormat.resturant
        case 3:
            return GenericActivityFormat.hotel
        default:
            return GenericActivityFormat.resturant
        }
    }
}

class ActivityCoderCoordinator
{

    private static var _instance: ActivityCoderCoordinator!

    class func shared(_ coder: NSCoder) -> ActivityCoderCoordinator
    {

        if _instance == nil
        {
            _instance = ActivityCoderCoordinator(coder)
        }
        else
        {
            _instance.coder = coder
        }
        return _instance
    }

    private var coder: NSCoder

    private init(_ coder: NSCoder)
    {
        self.coder = coder
    }

    func string(forKey key: String) -> String
    {
        return coder.decodeObject(forKey: key) as! String
    }

    func opString(forKey key: String) -> String?
    {
        return coder.decodeObject(forKey: key) as? String
    }

    func opInt(forKey key: String) -> Int?
    {
        return coder.decodeObject(forKey: key) as? Int
    }

    func opDouble(forKey key: String) -> Double?
    {
        return coder.decodeObject(forKey: key) as? Double
    }

    func opDate(forKey key: String) -> Date?
    {
        return coder.decodeObject(forKey: key) as? Date
    }

    func integer(forKey key: String) -> Int
    {
        return coder.decodeInteger(forKey: key)
    }

    func format(forKey key: String) -> GenericActivityFormat
    {
        let index = coder.decodeInteger(forKey: key)
        return GenericActivityFormat.format(forIndex: index)
    }

    func details() -> GenericActivityDetails
    {
        return coder.decodeObject(forKey: "details") as! GenericActivityDetails
    }

    func card() -> GenericActivityCard
    {
        return coder.decodeObject(forKey: "card") as! GenericActivityCard
    }

}


public class GenericActivity: NSObject, NSCoding
{

    public var id: String
    public var format: GenericActivityFormat
    public var type: String
    public var allCount: Int = -1
    public var nextPage: Int?

    public var name: String
    public var card: GenericActivityCard
    public var details: GenericActivityDetails

    init(id: String, name: String, format: GenericActivityFormat, type: String, card: GenericActivityCard, details: GenericActivityDetails)
    {

        self.id = id
        self.name = name
        self.type = type
        self.format = format

        self.card = card
        self.details = details
        super.init()
    }

    required public init?(coder aDecoder: NSCoder)
    {

        let cd = ActivityCoderCoordinator.shared(aDecoder)

        self.id = cd.string(forKey: "id")
        self.name = cd.string(forKey: "name")
        self.type = cd.string(forKey: "type")
        self.format = cd.format(forKey: "format")
        self.allCount = cd.integer(forKey: "allCount")
        self.nextPage = cd.opInt(forKey: "nextPage")

        self.details = cd.details()
        self.card = cd.card()
        super.init()
    }

    public func encode(with aCoder: NSCoder)
    {

        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.format.rawValue, forKey: "format")
        aCoder.encode(self.allCount, forKey: "allCount")
        aCoder.encode(self.nextPage, forKey: "nextPage")

        aCoder.encode(self.card, forKey: "card")
        aCoder.encode(self.details, forKey: "details")
    }
}

public class GenericActivityReview: NSObject, NSCoding
{

    public var name: String
    public var photoUrl: String?
    public var comment: String

    init(name: String, comment: String)
    {
        self.name = name
        self.comment = comment
        super.init()
    }

    required public init?(coder aDecoder: NSCoder)
    {

        let cd = ActivityCoderCoordinator.shared(aDecoder)

        self.name = cd.string(forKey: "name")
        self.photoUrl = cd.opString(forKey: "photoUrl")
        self.comment = cd.string(forKey: "comment")
        super.init()
    }

    public func encode(with aCoder: NSCoder)
    {

        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.photoUrl, forKey: "photoUrl")
        aCoder.encode(self.comment, forKey: "comment")
    }
}

public class GenericActivityFeature: NSObject, NSCoding
{

    public var label: String
    public var iconUrl: String

    init(label: String, iconUrl: String)
    {
        self.label = label
        self.iconUrl = iconUrl
        super.init()
    }

    required public init?(coder aDecoder: NSCoder)
    {

        let cd = ActivityCoderCoordinator.shared(aDecoder)

        self.label = cd.string(forKey: "label")
        self.iconUrl = cd.string(forKey: "iconUrl")
        super.init()
    }

    public func encode(with aCoder: NSCoder)
    {

        aCoder.encode(self.label, forKey: "label")
        aCoder.encode(self.iconUrl, forKey: "iconUrl")
    }
}

public class GenericActivityDetails: NSObject, NSCoding
{

    public var cuisine: [String] = []
    public var images: [String] = []
    public var reviews: [GenericActivityReview] = []

    public var bookUrl: String?
    public var openingHours: String?
    public var cityId: Int?

    public var ranking: String?
    public var ratingImageUrl: String?
    public var ratingPNGImageUrl: String?
    public var reviewsCount: Int = 0
    public var reviewsUrl: String?

    public var startDate: Date?
    public var endDate: Date?
    public var about: String?
    public var time: String?

    public var price: String?
    public var address: String?
    public var category: String?

    public var stars: String?
    public var features: [GenericActivityFeature] = []

    public var organizerName: String?
    public var phone: String?
    public var email: String?
    public var website: String?

    public var location: String?

    public func coordinates() -> CLLocationCoordinate2D
    {

        if let loc = self.location,
           let range = loc.range(of: ","),
           let lat = Double(loc.substring(to: range.lowerBound)),
           let lon = Double(loc.substring(from: range.upperBound))
        {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }

        return CLLocationCoordinate2D(latitude: 24.4520199, longitude: 54.382807) // Default to Abu Dhabi
    }

    public func date() -> String?
    {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "dd/MM/yyyy"

        var dateString = ""
        if let sdate = self.startDate
        {
            dateString += formatter.string(from: sdate)
        }

        if let edate = self.endDate
        {
            dateString += dateString.count > 0 ? " - " : ""
            dateString += formatter.string(from: edate)
        }

        return dateString.isEmpty ? nil : dateString
    }

    override init()
    {
        super.init()
    }

    required public init?(coder aDecoder: NSCoder)
    {

        let cd = ActivityCoderCoordinator.shared(aDecoder)

        self.reviewsCount = cd.integer(forKey: "reviewsCount")
        super.init()

        self.stars = cd.opString(forKey: "stars")
        self.startDate = cd.opDate(forKey: "startDate")
        self.endDate = cd.opDate(forKey: "endDate")

        self.bookUrl = cd.opString(forKey: "bookUrl")
        self.openingHours = cd.opString(forKey: "openingHours")
        self.ranking = cd.opString(forKey: "ranking")
        self.ratingImageUrl = cd.opString(forKey: "ratingImageUrl")
        self.ratingPNGImageUrl = cd.opString(forKey: "ratingPNGImageUrl")
        self.reviewsUrl = cd.opString(forKey: "reviewsUrl")
        self.about = cd.opString(forKey: "about")
        self.time = cd.opString(forKey: "time")
        self.price = cd.opString(forKey: "price")
        self.address = cd.opString(forKey: "address")
        self.category = cd.opString(forKey: "category")
        self.organizerName = cd.opString(forKey: "organizerName")
        self.phone = cd.opString(forKey: "phone")
        self.email = cd.opString(forKey: "email")
        self.website = cd.opString(forKey: "website")
        self.location = cd.opString(forKey: "location")

        self.cuisine = aDecoder.decodeObject(forKey: "cuisine") as? [String] ?? []
        self.images = aDecoder.decodeObject(forKey: "images") as? [String] ?? []
        self.reviews = aDecoder.decodeObject(forKey: "reviews") as? [GenericActivityReview] ?? []
        self.features = aDecoder.decodeObject(forKey: "features") as? [GenericActivityFeature] ?? []
    }

    public func encode(with aCoder: NSCoder)
    {

        aCoder.encode(self.stars, forKey: "stars")
        aCoder.encode(self.startDate, forKey: "startDate")
        aCoder.encode(self.endDate, forKey: "endDate")

        aCoder.encode(self.bookUrl, forKey: "bookUrl")
        aCoder.encode(self.openingHours, forKey: "openingHours")
        aCoder.encode(self.ranking, forKey: "ranking")
        aCoder.encode(self.ratingImageUrl, forKey: "ratingImageUrl")
        aCoder.encode(self.ratingPNGImageUrl, forKey: "ratingPNGImageUrl")
        aCoder.encode(self.reviewsUrl, forKey: "reviewsUrl")
        aCoder.encode(self.about, forKey: "about")
        aCoder.encode(self.time, forKey: "time")
        aCoder.encode(self.price, forKey: "price")
        aCoder.encode(self.address, forKey: "address")
        aCoder.encode(self.category, forKey: "category")
        aCoder.encode(self.organizerName, forKey: "organizerName")
        aCoder.encode(self.phone, forKey: "phone")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.website, forKey: "website")
        aCoder.encode(self.location, forKey: "location")

        aCoder.encode(self.reviewsCount, forKey: "reviewsCount")
        aCoder.encode(self.cuisine, forKey: "cuisine")
        aCoder.encode(self.images, forKey: "images")
        aCoder.encode(self.reviews, forKey: "reviews")
        aCoder.encode(self.features, forKey: "features")
    }
}

public class GenericActivityCard: NSObject, NSCoding
{

    public var desc: String?
    public var imageUrl: String
    public var image: UIImage?

    init(imageUrl: String)
    {
        self.imageUrl = imageUrl
        super.init()
    }

    required public init?(coder aDecoder: NSCoder)
    {

        let cd = ActivityCoderCoordinator.shared(aDecoder)

        self.desc = cd.opString(forKey: "desc")
        self.imageUrl = cd.string(forKey: "imageUrl")
        super.init()
    }

    public func encode(with aCoder: NSCoder)
    {

        aCoder.encode(self.desc, forKey: "desc")
        aCoder.encode(self.imageUrl, forKey: "imageUrl")
    }
}

public func parseGenericActivitysData(_ dataList: [[String: AnyObject]]) -> [GenericActivity]?
{

    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en")
    formatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"

    var allCount: Int?
    var places: [GenericActivity] = []
    for gplace in dataList
    {

        if let id = nonEmptyString(gplace["id"]),
           let format = gplace["format"] as? Int,
           let name = nonEmptyString(gplace["name"]),
           let info = gplace["info"] as? [String: AnyObject],
           let gcard = info["card"] as? [String: AnyObject],
           let gdetails = info["details"] as? [String: AnyObject],
           let imageUrl = nonEmptyString(gcard["image"])
        {

            let type = nonEmptyString(gplace["type"]) ?? "Place"
            let card = GenericActivityCard(imageUrl: imageUrl)
            card.desc = gcard["description"] as? String

            let details = GenericActivityDetails()

            if let loc = nonEmptyString(gdetails["location"])
            {
                details.location = loc
            }

            if let cityIdString = nonEmptyString(gdetails["city_id"]),
               let _cityId = Int(cityIdString)
            {

                details.cityId = _cityId
            }
            else if let _cityId = gdetails["city_id"] as? Int
            {

                details.cityId = _cityId
            }

            if let gcuisine = gdetails["cuisine"] as? [String]
            {
                details.cuisine.append(contentsOf: gcuisine)
            }

            if let gimages = gdetails["images"] as? [String]
            {
                details.images.append(contentsOf: gimages)
            }

            if let greviews = gdetails["reviews"] as? [[String: AnyObject]]
            {

                for grev in greviews
                {

                    if let name = grev["name"] as? String, let comment = grev["comment"] as? String
                    {

                        let prev = GenericActivityReview(name: name, comment: comment)
                        prev.photoUrl = grev["photoUrl"] as? String
                        details.reviews.append(prev)
                    }
                }
            }

            if let gfeatures = gdetails["features"] as? [[String: AnyObject]]
            {

                for gfet in gfeatures
                {

                    if let label = gfet["name"] as? String, let iconUrl = gfet["iconUrl"] as? String
                    {
                        details.features.append(GenericActivityFeature(label: label, iconUrl: iconUrl))
                    }
                }
            }

            let _startDateString = gdetails["start_date"] as? String ?? ""
            let _endDateString = gdetails["end_date"] as? String ?? ""

            details.startDate = formatter.date(from: _startDateString)
            details.endDate = formatter.date(from: _endDateString)

            details.bookUrl = nonEmptyString(gdetails["Book"])
            details.address = nonEmptyString(gdetails["address"])

            details.openingHours = nonEmptyString(gdetails["opening_hours"])
            details.phone = nonEmptyString(gdetails["phone"])
            details.price = nonEmptyString(gdetails["price"])
            details.ranking = nonEmptyString(gdetails["ranking"])
            details.ratingImageUrl = nonEmptyString(gdetails["rating"])
            details.ratingPNGImageUrl = nonEmptyString(gdetails["ratingpng"])

            details.reviewsCount = gdetails["reviews_count"] as? Int ?? 0

            details.stars = nonEmptyString(gdetails["stars"])
            details.about = nonEmptyString(gdetails["about"])
            details.time = nonEmptyString(gdetails["time"])
            details.category = nonEmptyString(gdetails["category"])

            details.organizerName = nonEmptyString(gdetails["organizer_name"])
            details.reviewsUrl = nonEmptyString(gdetails["reviewsUrl"])

            details.website = nonEmptyString(gdetails["website"])
            details.email = nonEmptyString(gdetails["email"])

            if allCount == nil
            {
                allCount = gplace["allcount"] as? Int
            }

            let place = GenericActivity(id: id, name: name,
                    format: GenericActivityFormat.format(forIndex: format),
                    type: type, card: card, details: details)

            place.nextPage = gplace["nextPage"] as? Int
            places.append(place)
        }
    }

    for place in places
    {
        place.allCount = allCount ?? places.count
    }

    return places.count > 0 ? places : nil
}

func nonEmptyString(_ obj: AnyObject?) -> String?
{

    if let str = obj as? String
    {

        var trimmedStr = str.trimmingCharacters(in: .whitespacesAndNewlines)
        trimmedStr = trimmedStr.count == 1
                ? trimmedStr.trimmingCharacters(in: CharacterSet(charactersIn: "-_"))
                : trimmedStr

        if trimmedStr.isEmpty == false
        {
            return trimmedStr
        }
    }

    return nil
}
