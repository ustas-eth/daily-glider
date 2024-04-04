# Function

Good day to learn about the `Function` methods, isn't it? `Function` is the second of our fundamental trio. It can be used to:

- Check the corresponding function's properties
- Get different types of instructions belonging to this function
- Work with arguments
- ...

> Don't forget about the `Callable` object, `Function` inherit its methods!

## Methods

From the most important methods, I can highlight the following:

- The group of property methods (`.is_internal()`, `.is_public()`, `.is_payable()`, etc.)
- The group of `Instructions` getters (`.if_instruction()`, `.asm_instructions()`, etc.)
- `.signature()`, `.hashed_signature()`, and `.name()`
- `.get_contract()` to step up to the contract
- `.arguments()` to get the `Arguments` object
- `.modifiers()` to get the `Modifiers` object
- `.dump_into_json()`, I'll make an additional article about it

There are about 40 methods in total, so make sure to check them all in the documentation [1](https://glide.gitbook.io/api/function) and [2](https://glide.gitbook.io/api/callable).

## Example

I'll share one of my unfinished glides as an example where I use `Function` to check the arguments:

```python
from glider import *


def query():
    instructions = (
        Functions()
        .with_one_property([MethodProp.EXTERNAL, MethodProp.PUBLIC])
        .with_all_properties([MethodProp.HAS_CALLEES])
        .with_arg_type("address")
        .with_modifiers_name_not(["onlyOwner", "onlyRole", "onlyAdmin"])
        .instructions()
        .external_calls()
        .with_called_function_name("transferFrom")
        .exec(100)
    )

    result = []
    for instruction in instructions:
        function = instruction.get_parent()
        addr_from = check_transfer_argument(instruction, function)

        if not addr_from:
            continue
        if not check_requirements(instruction, function, addr_from):
            continue

        result.append(instruction)

    return result


def check_transfer_argument(instruction, function):
    function_addr_args = function.arguments().with_type("address")
    calls = instruction.get_callee_values()

    for call in calls:
        if call.get_signature() == "transferFrom(address,address,uint256)":
            addr_from = call.get_args()[0]

            for function_addr_arg in function_addr_args:
                if addr_from.expression == function_addr_arg.name:
                    return function_addr_arg.name


def check_requirements(instruction, function, addr_from):
    return True

```

As you can see, I use `function = instruction.get_parent()` to step up from the instructions that contain `transferFrom()` call to their corresponding functions.

Then, in the `check_transfer_argument()` Python function, I query the function's arguments using `function.arguments().with_type("address")` and try to match between them and `transferFrom()` arguments to check whether the call uses arbitrary `from` value.

The glide is unfinished because of the empty `check_requirements()` in the end. There should be some algorithm to check whether the `from` variable is used in a `require` or `if`.

You can try to modify it and finish the function, I don't mind, just show me what it looks like afterward :)
