import ../../hash/hash as gohash

proc New*(h: proc(): gohash.Hash, key: seq[byte]): gohash.Hash = nil # Simplified
proc Equal*(mac1, mac2: seq[byte]): bool = mac1 == mac2
