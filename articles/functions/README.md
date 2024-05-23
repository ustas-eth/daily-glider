# Functions

The second element in the declarative part's [hierarchy](../boosting-declarative-part/README.md#boosting-the-declarative-part), `Functions`.

With `Functions`, you can perform filtration by:

- Function names (exact, negative exact, prefix, suffix, regexp)
- Function signatures (hashed, not hashed)
- Arguments (types, names, count)
- Modifiers
- Special properties (such as the Solidity function visibility)

> All the methods and properties of `Callables` ([docs](https://glide.gitbook.io/main/api/callables)) also apply to `Functions` ([docs](https://glide.gitbook.io/main/api/functions)) because the latter is a child class. Don't forget to look at both classes when searching for a method in the documentation.

## Example

```python
from glider import *


def query():
    functions = (
        Functions()
        .name_prefixes(["deposit", "withdraw"])
        .with_arg_type("address")
        .with_one_property([MethodProp.PUBLIC, MethodProp.EXTERNAL])
        .with_all_properties([MethodProp.HAS_STATE_VARIABLES_WRITTEN])
        .without_properties([MethodProp.HAS_MODIFIERS])
        .exec(1000)
    )

    result = []
    for function in functions:
        # arbitrary logic
        result.append(function)

    return result

```

> [!WARNING]
> UPD. Change `.name_prefixes` to `.with_name_prefixes` if you run this query on the mainnet Glider.

This glide returns all functions with the name `deposit*` or `withdraw*`, at least one argument of the `address` type, public or external visibility, and without any modifiers.

Like this one (from the results):

```solidity
function depositFor(address target) public override payable {
    uint256 amount = msg.value;
    require(amount <= config.maximumRecipientDeposit,"deposit too big");

    balances[target] = balances[target].add(amount);

    emit Deposited(target,msg.sender,amount);
}
```

## Special properties (aka MethodProp)

The `Functions` object has three methods to filter by the special `MethodProp` properties, mostly referring to functions' visibility (public/external/internal/private), state changes (view/pure/default), and the presence of arguments and modifiers. They all accept `List[MethodProp]`, as shown in the example above:

- `.with_all_properties()`: each property in the array should be true
- `.with_one_property()`: at least one of the properties should be true
- `.without_properties()`: the opposite of the first one; each property should be false

You can apply different combinations. The query will return nothing if there is a conflict (e.g., you put `MethodProp.HAS_STATE_VARIABLES_WRITTEN` and `MethodProp.IS_PURE` in `.with_all_properties()`, which obviously is impossible).

See the complete list of properties in the [documentation](https://glide.gitbook.io/main/api/callables/methodprop).

## Read next: [Instructions](../instructions/README.md)
