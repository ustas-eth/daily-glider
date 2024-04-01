# Instructions

`Instructions` and its twin `Instruction` are perhaps the most complex objects in Glider, with the most methods, because they represent the never-ending combinations of Solidity calls, calculations, variable assignments, conditions, etc.

From `Instructions`, you can filter out:

- Calls by type (external, delegate, static, low-level, internal...)
- Calls by name (exact, negative, signature, prefix, suffix)
- Conditions
- Assembly
- Entry points

# Example

```python
from glider import *


def query():
    instructions = (
        Functions()
        .with_one_property([MethodProp.PUBLIC, MethodProp.EXTERNAL])
        .instructions()
        .external_calls()
        .with_called_function_name("transferFrom")
        .exec(10)
    )

    result = []
    for instruction in instructions:
        # arbitrary logic
        result.append(instruction)

    return result

```

The glide above filters out only high-level functions and returns all instructions that contain an external call to `tranferFrom()`, such as this one:

```solidity
function transferFromERC20(IERC20 _token,uint256 _amount)
    public
    payable
    returns (uint256)
{
    uint256 erc20balance = _token.balanceOf(msg.sender);
    require(_amount <= erc20balance,"Balance is to low");
    _token.transferFrom(msg.sender,payable(address(this)),_amount);
    return erc20balance;
}
```

I have no idea what this example is supposed to do, why they use payable, why there's a redundant balance check :D But we can try to get the contract's source code; it's quite easy even without Etherscan (Kovan is deprecated).

Remember the [Debug Technique](../debug-technique/README.md)? Well, our contract is located on offset 1, so we have to change the `.exec()`, plus add a `print()` to the arbitrary part where we will first step up to the parent function and then to the contract, getting its source code:

```python
from glider import *


def query():
    instructions = (
        Functions()
        .with_one_property([MethodProp.PUBLIC, MethodProp.EXTERNAL])
        .instructions()
        .external_calls()
        .with_called_function_name("transferFrom")
        .exec(1, 1)
    )

    result = []
    for instruction in instructions:
        # arbitrary logic
        print(instruction.get_parent().get_contract().source_code())
        result.append(instruction)

    return result
```

And the result is here: https://gist.github.com/ustas-eth/5f84201b12c1556df2c0316ac3455870

Looks like its purpose is to accept payments for tours! Is this cypherpunk?

There's an unprotected transfer function, too:

```solidity
function transferERC20(
    IERC20 _token,address _to,uint256 _amount
) public {
    uint256 erc20balance = _token.balanceOf(address(this));
    require(_amount <= erc20balance,"Balance is to low");
    _token.transfer(_to,_amount);

}
```

And now I want to find them on the mainnet!

## Read next: [Contracts](../contracts/README.md)
