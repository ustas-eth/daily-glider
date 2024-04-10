# Contract

Now that we're done with the easy stuff, let's dive into complex arbitrary code. From top to bottom, we'll start with the `Contract` object.

## Methods

Consider the following example from the [article](../contracts/README.md) about `Contracts`:

```python
from glider import *


def query():
    contracts = (
        Contracts()
        .mains()
        .with_compiler_range("0.8.0", "0.8.26")
        .with_struct_name("Config")
        .exec(1, 1)
    )

    result = []
    for contract in contracts:
        # arbitrary logic
        print(contract.source_code())
        result.append(contract)

    return result

```

We can't do much with the declarative query anymore without descending to `Functions` or `Instructions`, but there are still many methods for the logic in the loop. About 20, to be precise, check the [documentation](https://glide.gitbook.io/main/api/contract).

The most useful are:

- `.source_code()`, which you've already seen
- `.name`, a property, returns the name of a contract
- `.address()`, returns the address of a contract
- `.enums/errors/events/structs()`, they are similar, return a list of the corresponding objects
- `.functions()`, to get the `Functions` of a contract
- `.variables()`, to get the `Variables` object, which contains the storage variables of a contract
- `.modifiers()`, same as the two above, but `Modifiers` (what did you expect)
- `.parent_contracts()`
- `.base_contracts()`
- `.derived_contracts()`

The last three are to work with the inheritance.

## Derived and inherited contracts

Let's stop now because this is one of the most interesting parts of the `Contract` object.

1. `.parent_contracts()` returns the inherited contracts without recursion.

For example, look at the glide below:

```python
from glider import *


def query():
    contracts = (
        Contracts()
        .mains()
        .exec(1, 1)
    )

    result = []
    for contract in contracts:
        print(contract.name)
        print(contract.source_code())

        result = contract.parent_contracts().exec()

    return result
```

It will return `ERC20Permit` and `Ownable` for the following contract:

```solidity
contract TestCoin is ERC20Permit, Ownable {
    ...
}
```

2. `.base_contracts()` is the same as `.parent_contracts()`, but with recursion enabled. This means it'll return `Context`, `EIP712`, `ERC20`, `IERC20`, and `IERC20Metadata` in addition to the `ERC20Permit` and `Ownable` for the same contract above.

3. The last one, `.derived_contracts()`, works in the opposite direction. It'll return contracts that use, for example, `IERC20` as a base:

```python
from glider import *


def query():
    contracts = (
        Contracts()
        .interfaces()
        .with_name("IERC20")
        .exec(1)
    )

    result = []
    for contract in contracts:
        print(contract.name)
        print(contract.source_code())

        result = contract.derived_contracts().exec()

    return result # ERC20, ERC20Permit, IERC20Metadata, TestCoin

```

> Don't forget to add `.exec()` after these methods because they return `Contracts` too. It's the same as with the declarative query in the beggining of glides, you can change the limit and the offset or add more filtration and descend to functions/instructions.

## Read next: [Function](../function/README.md)
