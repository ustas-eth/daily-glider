# Limit and offset

Let's take the query from the [previous article](../get-started/README.md) and change the name we're searching for to something more useful:

```python
from glider import *


def query():
    contracts = Contracts().with_name("ERC721").exec()
    return contracts

```

The first thing you'll probably notice after you try this query is the number of contracts - more than 4000! To keep it simple, let's limit this number:

```python
from glider import *


def query():
    contracts = Contracts().with_name("ERC721").exec(10)
    return contracts

```

The `.exec()` part always has two parameters: limit and offset. In this case, the first is the number of contracts you want to get, and the second is the number of contracts you want to skip.

Imagine you have a total pool of 4000 contracts:

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
