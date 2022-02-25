//
//  MapPointAnnotationView.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 15.02.2022.
//

import Foundation
import MapKit

class MapPointAnnotationView: MKAnnotationView {

static let ReuseID = "mapPointAnnotation"
        
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            clusteringIdentifier = "mapPoint"
            
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForDisplay() {
            super.prepareForDisplay()
            displayPriority = .defaultLow
            
            if let pointAnnotation = annotation as? MarkerAnnotation {
                let pulse = pointAnnotation.pulse
                
                if pointAnnotation.typeName == nil {
                    image = ClusterAnnotationView.drawRatio(0, to: pulse, fractionColor: nil)
                }else{
                    image = drawRatio(0, to: pulse, fractionColor: .red, wholeColor: .white)
                }

                
            }
        }
        
    static let glyphImage: UIImage = {
            let rect = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
            return UIGraphicsImageRenderer(bounds: rect).image { _ in
                let radius: CGFloat = 11
                let offset: CGFloat = 7
                let insetY: CGFloat = 5
                let center = CGPoint(x: rect.midX, y: rect.maxY - radius - insetY)
                let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi, clockwise: true)
                path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY + insetY), controlPoint: CGPoint(x: rect.midX - radius, y: center.y - offset))
                path.addQuadCurve(to: CGPoint(x: rect.midX + radius, y: center.y), controlPoint: CGPoint(x: rect.midX + radius, y: center.y - offset))
                path.close()
                UIColor.red.setFill()
                path.fill()
            }
        }()

        private func drawRatio(_ fraction: Int, to whole: Int, fractionColor: UIColor?, wholeColor: UIColor?) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
            return renderer.image { _ in
                // Fill full circle with wholeColor
                wholeColor?.setFill()
                UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()

                // Fill pie with fractionColor
                fractionColor?.setFill()
                let piePath = UIBezierPath()
                piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 10,
                               startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(fraction)) / CGFloat(whole),
                               clockwise: true)
                piePath.addLine(to: CGPoint(x: 20, y: 20))
                piePath.close()
                piePath.fill()

                // Fill inner circle with white color
                UIColor.red.setFill()
                UIBezierPath(ovalIn: CGRect(x: 4, y: 4, width: 32, height: 32)).fill()

                // Finally draw count text vertically and horizontally centered
                
                let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 8)]
                let text = whole.roundedWithAbbreviations
                let size = text.size(withAttributes: attributes)
                let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
                text.draw(in: rect, withAttributes: attributes)
            }
        }

    }
