
public struct Trade: CustomStringConvertible
{
    let buyer: Participant
    let seller: Participant
    let instrument: Instrument
    let quantity: Int32
    let price: Double
    
    public init(buyer: Participant, seller: Participant, instrument: Instrument, quantity: Int32, price: Double)
    {
        self.buyer = buyer
        self.seller = seller
        self.instrument = instrument
        self.quantity = quantity
        self.price = price
    }

    public var description: String {
        "\(Lookup.decode(buyer)):\(Lookup.decode(seller)):\(Lookup.decode(instrument)):\(quantity):\(price)"
    }
}
