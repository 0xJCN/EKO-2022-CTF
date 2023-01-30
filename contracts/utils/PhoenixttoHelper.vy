# @version ^0.3.7

owner: public(address)

@external
def reBorn():
    self.owner = tx.origin
