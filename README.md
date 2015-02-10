## Convergence model in TLA+

To help improve the shared understanding of how convergence locking
(SyncPoints) should protect resources in progress. Why TLA+? It's used by many
researchers and in industry ([at AWS][aws]) to find bugs prior to
implementation.

The easiest way to read the model is probably in [PDF format][pdf]. The ASCII
version (obviously) can't represent familiar math symbols.

### TLA+

TLA+ is a language designed to closely mirror mathematics to make it easy to
define systems in logical terms. More information on the language itself is
available at the [TLA+ project homepage][tla]

#### TLA+ Resources

1. [The Operators of TLA+][operators]
1. [TLA+ Cheat Sheet][cheat]
1. [Specifying systems (book)][specifyingsystems]

### Running the model

The easiest way is to download the [toolbox][toolbox] environment and use that,
but you can also just download the TLA+ checker if you want.

### License

Apache 2.0, see LICENSE.txt for details.


[tla]: http://research.microsoft.com/en-us/um/people/lamport/tla/tla.html
[toolbox]: http://research.microsoft.com/en-us/um/people/lamport/tla/toolbox.html
[operators]: http://www.hpl.hp.com/techreports/Compaq-DEC/SRC-TN-1997-006A.pdf
[cheat]: http://research.microsoft.com/en-us/um/people/lamport/tla/summary.pdf
[aws]: research.microsoft.com/en-us/um/people/lamport/tla/formal-methods-amazon.pdf
[specifyingsystems]: http://research.microsoft.com/en-us/um/people/lamport/tla/book.html
[pdf]: https://github.com/ryansb/heat-tla-model/blob/master/Heat.pdf
