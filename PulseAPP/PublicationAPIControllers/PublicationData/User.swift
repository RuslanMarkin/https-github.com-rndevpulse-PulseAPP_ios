

import Foundation
struct User : Codable {
	let id : String?
	let publicName : String?
	let name : String?
	let data : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case publicName = "publicName"
		case name = "name"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		publicName = try values.decodeIfPresent(String.self, forKey: .publicName)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		data = try values.decodeIfPresent(String.self, forKey: .data)
	}

}
