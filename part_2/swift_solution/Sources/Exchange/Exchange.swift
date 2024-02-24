import ExchangeLib
import ArgumentParser
import Parsing
import Foundation

#if os(Linux)
import Glibc
#else
import Darwin
#endif

@main
struct Exchange: ParsableCommand {

    @Argument(help: "The path of the order file.")
    var orderFilepath: String?

    mutating func run() throws {
        let exchange = ExchangeLib.Exchange()

        let order  = Parse(input: Slice<UnsafeBufferPointer<UInt8>>.self) {
            Prefix { $0 != UInt8(ascii: ":") }.map {Participant(ArraySlice<UInt8>($0))}
            StartsWith(":".utf8)
            Prefix { $0 != UInt8(ascii: ":") }.map {Instrument(ArraySlice<UInt8>($0))}
            StartsWith(":".utf8)
            Int.parser()
            StartsWith(":".utf8)
            Double.parser()
            Skip { Rest() }
        }

        if let orderFilepath {
            guard let file = fopen(orderFilepath, "r") else {
                fatalError("File at \(orderFilepath) not found.")
            }
            defer {
                fclose(file)
            }

            var buf = [CChar](repeating: 0, count: 128)

            while fgets(&buf, CInt(buf.count), file) != nil {
                let _ = buf.withUnsafeBufferPointer {
                    $0.withMemoryRebound(to: UInt8.self, {
                        if let o = try? order.parse($0) {
                            if o.2 > 0 {
                                for trade in exchange.insert(instrument: o.1,
                                                             order: Buy(participant:   o.0,
                                                            quantity: o.2, price: o.3)) {
                                    print(trade)
                                }
                            } else {
                                for trade in exchange.insert(instrument: o.1,
                                                             order: Sell(participant: o.0,
                                                            quantity: -o.2, price: o.3)) {
                                    print(trade)
                                }
                            }
                        }
                    })
                }
            }
        } else {
            var buf = [CChar](repeating: 0, count: 128)

            while fgets(&buf, CInt(buf.count), stdin) != nil {
                let _ = buf.withUnsafeBufferPointer {
                    $0.withMemoryRebound(to: UInt8.self, {
                        if let o = try? order.parse($0) {
                            if o.2 > 0 {
                                for trade in exchange.insert(instrument: o.1,
                                                             order: Buy(participant:   o.0,
                                                                        quantity: o.2, price: o.3)) {
                                    print(trade)
                                }
                            } else {
                                for trade in exchange.insert(instrument: o.1,
                                                             order: Sell(participant: o.0,
                                                                         quantity: -o.2, price: o.3)) {
                                    print(trade)
                                }
                            }
                        }
                    })
                }
            }
        }
    }
}


