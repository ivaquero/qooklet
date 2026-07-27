#import "@local/qooklet:0.1.0": *

#let example = toml("../0.1.0/src/config/info.toml").example
#cover(example)

#epigraph(info: example)[
  By `epigraph()`, you can add a quote or a saying at the beginning of the book.
]

#preface(info: example)[

  By `preface()`, you can add some information about the book.

  This template is inspired by #link("https://github.com/ParaN3xus/haobook")[haobook]. The main difference is that `qooklet` does not provide side-note features like the ones that `haobook` builds with #link("https://github.com/nleanba/typst-marginalia")[marginalia].

  This document serves both as a test document and a tutorial for the template. You can find the source code in `examples/example-book.typ`. The template is designed to be easy to customize for notes, short books, and scientific booklets.
]

#contents(depth: 2, info: example)

#part-page("Specifications", info: example)

#chapter(title: "Features", info: example)[

In this chapter, I will show you the features of this template.

= Builtin Styles

The public structure helpers are:

- Styles:
  - `chapter(title: title, info: info)[body]`: Add a styled chapter.
  - `appendix(title: title, info: info)[body]`: Add a styled appendix.
  - `front-matter-style(body)`: Style for front matter pages.
- Pages:
  - `cover(info, date: datetime.today())`: Add a cover page to the document.
  - `epigraph(info: info)[body]`: Add an epigraph page to the document.
  - `preface(info: info)[body]`: Add a preface page to the document.
  - `part-page(title, info: info)`: Add a part divider page to the document.
  - `contents(depth: depth, info: info)`: Add a table of contents to the document.

= Two Modes

The default mode is note mode, when `cover()` is called the booklet mode will be activated.

= Tweakable Config

The `info` argument in `cover()`, `preface()`, `contents()`, `part-page()`, `chapter()`, and `appendix()` lets you customize document metadata through a TOML file. If you leave it unspecified, Qooklet uses the empty default metadata from `config/info.toml`.

Read your info file like this:

```typst
#let info = toml("your path").key-you-like
```

The toml file should look like this

```toml
[key-you-like]
    title = "Your Booklet Name"
    author = "Your Name"
    footer = "Some Info You Want to Show"
    header = "Some Info You Want to Show"
    lang = "en" # or "zh"
```

= Theorems

The theorem environment is implemented by #link("https://github.com/OrangeX4/typst-theorion")[theorion].
]

#chapter(title: "Usage of the Template", info: example)[

The template is designed to be easy to use. You can use it to create a booklet or a note with a beautiful layout.

= Importing the Template

To use the published template, import it from Typst Universe:

```typ
#import "@preview/qooklet:0.6.2": *
```

For local development, clone the repository to your `@local` workspace:

- Linux：
  - `$XDG_DATA_HOME/typst/packages/local`
  - `~/.local/share/typst/packages/local`
- macOS：`~/Library/Application\ Support/typst/packages/local`
- Windows：`%APPDATA%/typst/packages/local`

```typ
#import "@local/qooklet:0.1.0": *
```

= Suggested Document Structure

Overall, your document should be structured like this:

```typ
#import "@local/qooklet:0.1.0": *

#let info = toml("../0.1.0/src/config/info.toml").example

// add a cover
#cover(info, date: datetime.today())

#epigraph(info: info)[
  // Add an epigraph to the document.
]

#preface(info: info)[
  // Add a preface to the document.
]

#contents(depth: 2, info: info)

#part-page("Main Text", info: info)

// body
#chapter(
  title: "Chapter Title 1",
  info: info,
)[
  ...
]

#chapter(
  title: "Chapter Title 2",
  info: info,
)[
  ...
]

// appendix
#part-page("Appendix", info: info)

#appendix(
  title: "Appendix Title 1",
  info: info,
)[
  ...
]

#appendix(
  title: "Appendix Title 2",
  info: info,
)[
  ...
]
```
]

#chapter(title: "Some Examples", info: example)[

= Bellman Equation

#definition(title: "Bellman Equation")[

  ...

  $
    text(v_π (s), fill: #rgb("#ff0000")) & = 𝔼[R_(t+1)|S_t = s] + γ 𝔼[G_(t+1)|S_t = s], \
                                         & = ∑_(a ∈ 𝒜) π(a|s) ∑_(r ∈ ℛ) p(r|s,a) +
                                           γ ∑_(a ∈ 𝒜) π(a|s) ∑_(s^′ ∈ 𝒮) p(s^′|s,a) v_π (s^′) \
                                         & = ∑_(a ∈ 𝒜) π(a|s) [∑_(r ∈ ℛ) p(r|s,a) r +
                                             γ ∑_(s^′ ∈ 𝒮) p(s^′|s,a) text(v_π (s^′), fill: #rgb("#ff0000"))], ∀s ∈ 𝒮
  $ <bellman>
]

= Bellman Optimal Equation

By Eq. @bellman,...

$
  v(s) & = max_(π(s) ∈ ∏(s)) ∑_(a ∈ 𝒜) π(a|s)(∑_(r ∈ ℛ) p(r|s, a) r + γ ∑_(s^′ ∈ 𝒮) p(s^′|s, a) v(s^′)), quad & ∀s ∈ 𝒮 \
       & = max_(π(s) ∈ ∏(s)) ∑_(a ∈ 𝒜) π(a|s) q(s, a), quad                                                   & ∀s ∈ 𝒮
$ <boe>

= Case: Shortest Path of Islands

```typst
#let csv1 = csv("islands.csv")
#figure(
  tableq(csv1, 9, inset: 0.31em),
  caption: "Geographic Info of Islands",
  supplement: "Table",
  kind: table,
)
```

#let csv1 = csv("islands.csv")
#figure(
  tableq(csv1, 9, inset: 0.31em),
  caption: "Geographic Info of Islands",
  supplement: "Table",
  kind: table,
)
]

#part-page("Appendix", info: example)

#appendix(title: "Bibliography", info: example)[

#bibliography("bib.bib", title: none)
]
