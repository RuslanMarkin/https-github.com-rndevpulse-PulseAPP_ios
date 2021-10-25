/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

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