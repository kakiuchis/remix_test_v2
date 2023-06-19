# A basic ERC20 token contract in Vyper

# Events that are issued when the functions are called
# Transfer: event({_from: indexed(address), _to: indexed(address), _value: uint256})

balances: public(HashMap[address, uint256])

@external
@payable
def __init__():
    self.balances[msg.sender] = 10000  # The deployer gets all initial tokens

@external
def transfer(_to: address, _value: uint256) -> bool:
    _from: address = msg.sender

    # Check if the sender has enough
    assert self.balances[_from] >= _value, "Insufficient balance"

    # Subtract from the sender
    self.balances[_from] -= _value

    # Add to the recipient
    self.balances[_to] += _value

    # Log the transfer event
    # log Transfer(_from, _to, _value)

    return True