# Limit and offset

Let's take the query from the [previous article](../get-started/README.md) and change the name we're searching for to something more useful:

```python
from glider import *


def query():
    contracts = Contracts().with_name("ERC721").exec()
    return contracts

```

The first thing you'll probably notice after you try this query is the number of contracts - more than 4000! You can see it in the Performance tab.

To keep it simple, let's limit this number:

```python
from glider import *


def query():
    contracts = Contracts().with_name("ERC721").exec(10)
    return contracts

```

The `.exec()` part has two parameters: limit and offset. The first is the number of contracts you want to get, and the second is the number of contracts you want to skip. You can write only the limit and drop the offset (as we did above), then the offset will be 0.

To get a better intuition about them, imagine you have a total pool of 4000 contracts:

```
=================================================
```

1. You can query all these contracts by simply leaving the `.exec()` empty:

```
↓ - - - - - - - - - - - - - - - - - - - - - - - ↓
=================================================
```

2. You can get the first 500 with `.exec(500)`:

```
↓ - - ↓
=================================================
```

3. Or the third 500 with `.exec(500, 1000)`:

```
              ↓ - - ↓
=================================================
```

These parameters are very handy in debugging when unsure what contract is causing an error.

## Read next: [Arbitrary Logic](../arbitrary-logic/README.md)
