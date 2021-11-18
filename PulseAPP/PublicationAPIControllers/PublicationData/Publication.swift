

import Foundation
struct Publication : Codable {
	let id : String?
	let description : String?
	let geoposition : [Double]?
	let userId : String?
	let publicationCategories : [PublicationCategories]?
	let datePublication : String?
	let countViews : Int?
	let countLikes : Int?
	let countComments : Int?
	let countPublications : String?
	let countPulse : Int?
	let moderation : String?
	let caption : String?
	let begin : String?
	let end : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case description = "description"
		case geoposition = "geoposition"
		case userId = "userId"
		case publicationCategories = "publicationCategories"
		case datePublication = "datePublication"
		case countViews = "countViews"
		case countLikes = "countLikes"
		case countComments = "countComments"
		case countPublications = "countPublications"
		case countPulse = "countPulse"
		case moderation = "moderation"
		case caption = "caption"
		case begin = "begin"
		case end = "end"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		geoposition = try values.decodeIfPresent([Double].self, forKey: .geoposition)
		userId = try values.decodeIfPresent(String.self, forKey: .userId)
		publicationCategories = try values.decodeIfPresent([PublicationCategories].self, forKey: .publicationCategories)
		datePublication = try values.decodeIfPresent(String.self, forKey: .datePublication)
		countViews = try values.decodeIfPresent(Int.self, forKey: .countViews)
		countLikes = try values.decodeIfPresent(Int.self, forKey: .countLikes)
		countComments = try values.decodeIfPresent(Int.self, forKey: .countComments)
		countPublications = try values.decodeIfPresent(String.self, forKey: .countPublications)
		countPulse = try values.decodeIfPresent(Int.self, forKey: .countPulse)
		moderation = try values.decodeIfPresent(String.self, forKey: .moderation)
		caption = try values.decodeIfPresent(String.self, forKey: .caption)
		begin = try values.decodeIfPresent(String.self, forKey: .begin)
		end = try values.decodeIfPresent(String.self, forKey: .end)
	}

}