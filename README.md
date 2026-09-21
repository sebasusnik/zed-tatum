# zed-synth

Zed language support for the `.synth` DSL that
[synth-core](https://github.com/sebasusnik/synth-core) plays.

Syntax highlighting, bracket matching, auto-indent, and an outline
(`cmd-shift-o`) of a song's modules, patterns, tracks and scenes.

The parser is [tree-sitter-synth](https://github.com/sebasusnik/tree-sitter-synth). This repo is only the
editor half: `extension.toml` says which grammar to build, and
`languages/synth/` says how to colour it.

## Installing it

Zed has no CLI for this, so it is a two-step from inside the editor:

1. `cmd-shift-p` → **zed: install dev extension**
2. pick this directory (`~/dev/zed-synth`)

Zed clones the grammar from the URL in `extension.toml`, compiles it,
and applies it to every `.synth` file straight away. After changing anything
here, reinstall the dev extension the same way (Zed also has a **reload
extensions** action, which is the quicker path when it is available).

The grammar is pinned by commit, and Zed caches the build per revision. So
after changing `grammar.js` in tree-sitter-synth:

```
cd ../tree-sitter-synth
npx tree-sitter generate && npx tree-sitter test
git commit -am "..."
cd ../zed-synth
./sync.sh          # copies the queries over and repoints extension.toml
```

then reinstall or reload the extension in Zed. Skipping the `rev` bump is the
one mistake that looks like "my change did nothing": Zed will happily keep the
old build.

## How it reads a song

The colours are chosen for the thing you actually stare at, which is a pattern
grid:

| written | reads as |
| --- | --- |
| `X` accent | the strongest colour on the line |
| `x` hit | bright |
| `o` `g` ghost | dimmed — felt more than heard |
| `-` rest, `..` tie | as quiet as a comment |
| `A4` `1.2` `Fm9` | pitch: notes, degrees and chords are literals |
| `cutoff` `wet=` | parameters |
| `poly` `bars_8` `saw` | option words |
| `lowpass(...)` | effects, like function calls |
| `module` `track` `play` | keywords |

Everything you name — a module, a pattern, a track, a scene, a bus — is
coloured as a definition where it is defined and as a plain reference where it
is used, so `play riff` points at `pattern riff` by eye.

## Publishing

To put this on the Zed extension registry, open a PR against
[zed-industries/extensions](https://github.com/zed-industries/extensions)
adding this repo as a submodule and an entry in `extensions.toml`.

## License

MIT
