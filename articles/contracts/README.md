# Contracts

We've covered the object a little in the previous articles, so you should already be quite familiar with it.

Anyway, `Contracts` is the starting point of a declarative query, the highest level, and the smallest number of instances. You can filter contracts by the following parameters:

- Names (exact, negative, prefix, suffix, regexp)
- Compiler versions (by range, e.g., 0.6.0 - 0.8.25)
- Error and event names and signatures
- Function names
- Struct names and nested types
- Interfaces and main (high-level) contracts

## Example

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

Check a contract from the result: https://gist.github.com/ustas-eth/ff309a6a07b56fee0fda4e68caf1bb47

The pragma version is 0.8.1, and it has a struct with the name `Config`, too, just as requested:

```solidity
    struct Config {
        uint256 lockupPeriod;
        uint256 minAmount;
        IERC20 depositedIn;
    }
```

The contract's name is `DebtVault`, so I assume it's supposed to keep money. It also inherits from `Administrable`, which seems similar to the usual `Ownable`, and `ERC721Lite`, obviously a variation of the ERC721 standard, which I never heard of. You can try to get their source codes with `Contract.parent_contracts()` ([docs](https://glide.gitbook.io/main/api/contract/contract.parent_contracts)) like this:

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
        parents = contract.parent_contracts().exec()

        for parent in parents:
            print(parent.source_code())

        result.append(contract)

    return result

```

## Read next: [Setup and Writing Style](../setup-and-style/README.md)
