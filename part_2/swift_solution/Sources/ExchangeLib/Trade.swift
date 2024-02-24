
public struct Trade: CustomStringConvertible
{
    let buyer: Participant
    let seller: Participant
    let instrument: Instrument
    let quantity: Int
    let price: Double
    
    public init(buyer: Participant, seller: Participant, instrument: Instrument, quantity: Int, price: Double)
    {
        self.buyer = buyer
        self.seller = seller
        self.instrument = instrument
        self.quantity = quantity
        self.price = price
    }

    public var description: String {
        "\(buyer):\(seller):\(instrument):\(quantity):\(price)"
    }
}
