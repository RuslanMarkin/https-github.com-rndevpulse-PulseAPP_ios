//
//  FilterGlobalPoints.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 21.02.2022.
//

import Foundation




class FilterGlobalPoints: Codable {
    var Lat : Double = 0
    var Lon : Double = 0
    var Category : [String] = ["PUBLICATIONCATEGORY.Food",
                               "PUBLICATIONCATEGORY.Transport",
                               "PUBLICATIONCATEGORY.Nature",
                               "PUBLICATIONCATEGORY.Excursion",
                               "PUBLICATIONCATEGORY.Monument",
                               "PUBLICATIONCATEGORY.Design",
                               "PUBLICATIONCATEGORY.Music",
                               "PUBLICATIONCATEGORY.Dances",
                               "PUBLICATIONCATEGORY.Interior",
                               "PUBLICATIONCATEGORY.People",
                               "PUBLICATIONCATEGORY.Concert"]
    var Types : [String] = ["PUBLICATIONTYPE.Post",
                            "PUBLICATIONTYPE.Event",
                            "PUBLICATIONTYPE.MapObject",
                            "PUBLICATIONTYPE.Organization",
                            "PUBLICATIONTYPE.Route"]

    }
