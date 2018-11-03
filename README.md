# `nixfmt`, A Normalising formatter for Nix Code

`nixfmt` uses [`hnix`](http://hackage.haskell.org/package/hnix) for parsing and formatting.
It does not do any of the heavy lifting itself. Only the option parsing is custom.

NOTE: `nixfmt` does not retain comments in the code.
This is because `hnix` doesn't either: See [their expression type](http://hackage.haskell.org/package/hnix-0.5.2/docs/Nix-Expr-Types.html#t:NExprF) for more information.
See also [the relevant issue on the hnix issue tracker](https://github.com/haskell-nix/hnix/issues/57).
