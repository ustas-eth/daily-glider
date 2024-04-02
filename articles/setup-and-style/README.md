# Setup and Writing Style

Today, we will talk about the maintainability of your glides.

I know this is not the most exciting thing to read about, and I should've written about it after the first article, but I'd like to cover this topic before we get to more complex arbitrary code.

Glides require updates sometimes to cover a new version of Solidity or a library. And you don't want to spend the entire morning analyzing the glide you made six months ago, do you?

## Setup

Let's start with what I usually use to keep my code clean.

- VS Code (or rather [VS Codium](https://vscodium.com/))
- [Black Formatter](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter) (any other formatter for Python will do as well)
- [JSON Formatter](https://marketplace.visualstudio.com/items?itemName=ClemensPeters.format-json)
- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

A Python formatter is a must because the editor on the website doesn't have one built-in (work in progress).

You need the last two to deal with the copied Glider output. Sometimes, it's messy, but it can be quickly improved with these two plugins.

## Writing style

The general rules apply; refer to these guides:

- The golden standard https://peps.python.org/pep-0008/
- Same, but in video https://www.youtube.com/watch?v=D4_s3q038I0&t=149s
- Same, but on another website https://docs.python-guide.org/writing/style/

There are differences when you write in Glider, of course, because it doesn't use the full version of Python. For example, you can't separate code into two files.

The main takes from the articles:

1. Use 4 spaces for the indentation.
2. Break your code into logical blocks with blank lines.
3. Use parenthesis instead of backslashes when you break lines (with rare exceptions).
4. Use clear names for variables and functions.

Bad code (though not the ugliest I've seen):

```python
from glider import *
def query():
  ins = Functions()\
    .with_one_property([MethodProp.EXTERNAL, MethodProp.PUBLIC])\
    .without_properties([MethodProp.HAS_MODIFIERS,MethodProp.IS_CONSTRUCTOR])\
    .instructions().with_called_function_name("selfdestruct").exec(1)
  x = []
  for i in ins:
   x.append(i.get_parent())
  return x
```

Good code:

```python
from glider import *


def query():
    instructions = (
        Functions()
        .with_one_property([MethodProp.EXTERNAL, MethodProp.PUBLIC])
        .without_properties([MethodProp.HAS_MODIFIERS, MethodProp.IS_CONSTRUCTOR])
        .instructions()
        .with_called_function_name("selfdestruct")
        .exec(1)
    )

    result = []
    for instruction in instructions:
        parent = instruction.get_parent()
        result.append(parent)

    return result
```

## Functions

Sometimes, when a glide becomes too bloaty, I break it into functions to abstract a little. There's a big downside right now, unfortunately. The profiler only works on the main `query()` function, though it'll still show you the overall performance of an inner function in the place where you call it. The next lesson will probably be about the profiler.

```python
from glider import *


def query():
    instructions = (
        Functions()
        .with_one_property([MethodProp.EXTERNAL, MethodProp.PUBLIC])
        .without_properties([MethodProp.HAS_MODIFIERS, MethodProp.IS_CONSTRUCTOR])
        .instructions()
        .with_called_function_name("selfdestruct")
        .exec(1)
    )

    return process(instructions)


def process(instructions):
    result = []

    for instruction in instructions:
        parent = instruction.get_parent()
        result.append(parent)

    return result

```
