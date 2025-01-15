
// multi-languages
#import "@preview/linguify:0.4.1": *
// indent
#import "@preview/indenta:0.0.3": fix-indent
// header-footer
#import "@preview/hydra:0.5.2": *
// checklist
#import "@preview/cheq:0.2.2": checklist
// chemistry
#import "@preview/whalogen:0.2.0": ce
// physics
#import "@preview/physica:0.9.4": *
// theorems
#import "@preview/ctheorems:1.1.3": *
// banners
#import "@preview/gentle-clues:1.1.0": *
// subfigures
#import "@preview/subpar:0.2.0": grid as sgrid
// wrap
#import "@preview/wrap-it:0.1.1": wrap-content
// diagram
#import "@preview/fletcher:0.5.4": diagram, node, edge
// numbering
#import "@preview/i-figured:0.2.4"
// codes
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.4": *
// annot
#import "@preview/pinit:0.2.2": *
// excel
#import "@preview/rexllent:0.2.3": xlsx-parser

#let conf(
  title: none,
  author: (),
  header-cap: [],
  footer-cap: [],
  outline-on: true,
  eqnumstyle: "1",
  eqnumsep: ".",
  eqnumlevel: 1,
  par-leading: 1em,
  list-indent: 1.2em,
  block-above: 1em,
  block-below: 0.5em,
  figure-break: false,
  lang: "zh",
  doc,
) = {
  set page(
    paper: "a4",
    numbering: "1",
    header: context {
      set text(size: 8pt)
      if calc.odd(here().page()) {
        align(right, [#header-cap #h(6fr) #emph(hydra(1))])
      } else {
        align(left, [#emph(hydra(1)) #h(6fr) #header-cap])
      }
      line(length: 100%)
    },
    footer: context {
      set text(size: 8pt)
      let page_num = here().page()
      if calc.odd(page_num) {
        align(
          right,
          [#footer-cap #datetime.today().display("[year]-[month]-[day]") #h(6fr) #page_num],
        )
      } else {
        align(
          left,
          [#page_num #h(6fr) #footer-cap #datetime.today().display("[year]-[month]-[day]")],
        )
      }
    },
  )
  set heading(numbering: "1.1")

  set par(
    first-line-indent: 2em,
    justify: true,
    leading: par-leading,
    linebreaks: "optimized",
  )
  set block(above: block-above, below: block-below)
  set list(indent: list-indent)
  set enum(indent: list-indent)

  let fonts = toml("fonts.toml")
  set text(
    font: fonts.at(lang).context,
    size: 10.5pt,
    lang: lang,
  )

  let lang_data = toml("lang.toml")
  set-database(lang_data)

  set ref(
    supplement: it => {
      if it.func() == heading {
        linguify("chapter")
      } else if it.func() == table {
        it.caption
      } else if it.func() == image {
        it.caption
      } else if it.func() == figure {
        it.supplement
      } else if it.func() == math.equation {
        linguify("eq")
      } else { }
    },
  )

  show heading: i-figured.reset-counters.with(level: 2)
  show math.equation: i-figured.show-equation

  show figure.caption: it => [
    #it.supplement
    #context it.counter.display(it.numbering)
    #it.body
  ]
  show figure.where(kind: table): set figure.caption(position: top)

  codly(
    languages: codly-languages,
    fill: rgb("#F2F3F4"),
    zebra-fill: none,
    inset: (x: .3em, y: .3em),
    stroke: -1pt + rgb("#000000"),
    radius: .5em,
  )
  show: codly-init.with()

  align(
    center,
    text(size: 20pt, font: fonts.at(lang).title)[
      *#title*
    ],
  )

  if outline-on == true {
    outline(
      title: lang_data.lang.at(lang).content,
      indent: auto,
      depth: 2,
    )
    pagebreak()
  }

  show link: underline
  show: thmrules
  show: fix-indent()
  doc
}

// text
#let fonts = toml("fonts.toml")
#let ctext(body) = text(body, font: fonts.at("zh").math)

// tables
#let frame(stroke) = (
  (x, y) => (
    top: if y < 2 {
      stroke
    } else {
      0pt
    },
    bottom: stroke,
  )
)

// tables
#let frame2(stroke) = (
  (x, y) => (
    left: if x > 2 {
      stroke
    } else {
      0pt
    },
    top: stroke,
    bottom: stroke,
  )
)

#let ktable(data, k, inset: 0.3em) = table(
  columns: k,
  inset: inset,
  align: center + horizon,
  stroke: frame(rgb("000")),
  ..data.flatten(),
)

// codes
#let code(text, lang: "python", breakable: true, width: 100%) = block(
  fill: rgb("#F3F3F3"),
  stroke: rgb("#DBDBDB"),
  inset: (x: 1em, y: 1em),
  outset: -.3em,
  radius: 5pt,
  spacing: 1em,
  breakable: breakable,
  width: width,
  raw(
    text,
    lang: lang,
    align: left,
    block: true,
  ),
)

// theorems
#let definition = thmbox(
  "definition",
  text(linguify("definition")),
  base_level: 1,
  separator: [#h(0.5em)],
  padding: (top: 0em, bottom: 0em),
  fill: rgb("#FFFFFF"),
  // stroke: rgb("#000000"),
  inset: (left: 0em, right: 0.5em, top: 0.2em, bottom: 0.2em),
)

#let theorem = thmbox(
  "theorem",
  text(linguify("theorem")),
  base_level: 1,
  separator: [#h(0.5em)],
  padding: (top: 0em, bottom: 0.2em),
  fill: rgb("#E5EEFC"),
  // stroke: rgb("#000000")
)

#let lemma = thmbox(
  "theorem",
  text(linguify("lemma")),
  separator: [#h(0.5em)],
  fill: rgb("#EFE6FF"),
  titlefmt: strong,
)

#let corollary = thmbox(
  "corollary",
  text(linguify("corollary")),
  // base: "theorem",
  separator: [#h(0.5em)],
  titlefmt: strong,
)

#let rule = thmbox(
  "",
  text(linguify("rule")),
  base_level: 1,
  separator: [#h(0.5em)],
  fill: rgb("#EEFFF1"),
  titlefmt: strong,
)

#let algo = thmbox(
  "",
  text(linguify("algorithm")),
  base_level: 1,
  separator: [#h(0.5em)],
  padding: (top: 0em, bottom: 0.2em),
  fill: rgb("#FAF2FB"),
  titlefmt: strong,
)

// banners
#let tip(title: text(linguify("tip")), icon: emoji.lightbulb, ..args) = clue(
  accent-color: yellow,
  title: title,
  icon: icon,
  ..args,
)

#let alert(title: text(linguify("alert")), icon: emoji.excl, ..args) = clue(
  accent-color: red,
  title: title,
  icon: icon,
  ..args,
)
