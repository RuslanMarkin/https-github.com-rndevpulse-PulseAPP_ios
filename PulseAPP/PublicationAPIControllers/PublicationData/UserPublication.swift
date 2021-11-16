

import Foundation
struct UserPublication : Codable {
	let user : User?
	let publication : Publication?
	let publicationType : PublicationType?
	let files : [String]?

	enum CodingKeys: String, CodingKey {

		case user = "user"
		case publication = "publication"
		case publicationType = "publicationType"
		case files = "files"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		user = try values.decodeIfPresent(User.self, forKey: .user)
		publication = try values.decodeIfPresent(Publication.self, forKey: .publication)
		publicationType = try values.decodeIfPresent(PublicationType.self, forKey: .publicationType)
		files = try values.decodeIfPresent([String].self, forKey: .files)
	}

}
