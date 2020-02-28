//
//  PaymentTypeNew.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Payment Types.
@objc public enum PaymentType: Int, CaseIterable {

	/// All payment types.
	@objc(all) case all
	
    /// Only card payments.
    @objc(card) case card
    
    /// Only web payments.
    @objc(web) case web
	

	

	
	// MARK: - Internal -
	// MARK: Properties
	
	/// Default payment type.
	internal static let `default`: PaymentType = .all
	
    // MARK: - Private -
    // MARK: Properties
    
    private var stringRepresentation: String {
        
        switch self {
			
		case .all:			return "all"
        case .card:        	return "card"
        case .web: 			return "web"

        }
    }
    
    // MARK: Methods
    
    private init(stringRepresentation: String) {
        
        switch stringRepresentation {
		
		case PaymentType.all.stringRepresentation:
		
		self = .all
            
        case PaymentType.card.stringRepresentation:
            
            self = .card
            
        case PaymentType.web.stringRepresentation:
            
            self = .web
		
			
        default:
            
			self = .all
        }
    }
}

// MARK: - CustomStringConvertible
extension PaymentType: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
		
		case .all:		return "all"
        case .card:		return "card"
        case .web:		return "web"

        }
    }
}

// MARK: - Encodable
extension PaymentType: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringRepresentation)
    }
}

// MARK: - Decodable
extension PaymentType: Decodable {
	
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        self.init(stringRepresentation: stringValue)
    }
}
