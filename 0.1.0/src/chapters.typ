#import "deps.typ": *
#import "common.typ": *
#import "referable.typ": *

#let prefixed-counter(prefix, chapter-format, appendix-format) = {
  if prefix == "chapter" {
    counter-chapter.display(chapter-format)
  } else if prefix == "appendix" {
    counter-appendix.display(appendix-format)
  }
}

#let page-has-first-level-one-heading() = {
  let headings = query(heading.where(level: 1))
  headings != () and headings.first().location().page() == here().page()
}

#let chapter-title(
  title,
  lang: "en",
  prefix: "chapter",
  styles: default-styles,
  chapter-break: () => pagebreak(weak: true, to: "odd"),
) = {
  let the-title = text(
    title,
    size: styles.sizes.chapter * 1pt,
    font: styles.fonts.at(lang).chapter,
    style: "italic",
    weight: "bold",
  )

  context if not book-state.get() {
    the-title
    v(2em)
  } else {
    chapter-break()
    show figure.caption: none
    let chapter-idx = context prefixed-counter(prefix, "1", "A")

    let bottom-pad = 10%
    block(height: 50%, grid(
      columns: (10fr, 1fr, 2fr),
      rows: (2fr, 12fr),
      align: (right + bottom, center, left + bottom),
      place(right + bottom, dx: -1%, pad(
        figure(
          the-title,
          kind: prefix,
          supplement: none,
          numbering: _ => none,
          caption: title,
        ),
        bottom: bottom-pad,
      )),
      line(angle: 90deg, length: 100%),
      pad(text(
        chapter-idx,
        size: styles.sizes.chapter-index * 1pt,
        font: styles.fonts.at(lang).chapter-index,
        weight: "bold",
      )),
    ))
  }
}

#let chapter-odd-pagebreak(.._ignored) = {
  context if calc.odd(here().page()) {
    pagebreak(weak: true)
    {
      set page(header: none, footer: none)
      pagebreak(weak: true, to: "odd")
    }
  } else {
    pagebreak(weak: true, to: "odd")
  }
}

#let chapter-img(img, title: "") = {
  block(place(right + bottom, dx: 1%, figure(
    img,
    placement: top,
    kind: "chapimg",
    supplement: none,
    numbering: _ => none,
    caption: title,
  )))
}

#let heading-size-style(
  x,
  lang: "en",
  styles: default-styles,
) = {
  for level in range(1, 5) {
    show heading.where(level: level): set text(
      size: styles.sizes.at("heading-" + str(level)) * 1pt,
    )
  }
  x
  v(1em, weak: true)
}

#let heading-numbering(
  ..numbers,
  prefix: "chapter",
  heading-depth: 3,
) = {
  let is-book = book-state.get()
  let the-prefix = if is-book { prefixed-counter(prefix, "1.", "A.") } else { "" }
  let level = numbers.pos().len()
  if level <= 2 or (level == 3 and not is-book and heading-depth == 3) {
    the-prefix + numbering("1.", ..numbers)
  } else {
    h(-0.33em)
  }
}

#let align-odd-even(odd-left, odd-right, hide: false) = {
  let chapter-page = query(selector(fig-chapter).or(fig-appendix))
    .filter(h => h.location().page() == here().page())
    .len()

  if not (hide and chapter-page == 1) {
    if calc.odd(here().page()) {
      align(right, [#odd-left #h(6fr) #odd-right])
    } else {
      align(right, [#odd-right #h(6fr) #odd-left])
    }
  }
}

#let chapter-style(
  body,
  title: "",
  info: default-info,
  styles: default-styles,
  names: default-names,
  outline-on: false,
  prefix: "chapter",
  heading-depth: 3,
) = {
  assert(
    heading-depth in (1, 2, 3),
    message: "depth can only be either 1, 2 or 3",
  )

  let header = info.header
  let footer = info.footer
  let lang = info.lang

  show: common-style
  show: book-style.with(styles: styles)

  set par(
    first-line-indent: (
      amount: styles.spaces.par-indent * 1em,
      all: lang == "zh",
    ),
    justify: true,
    leading: styles.spaces.par-leading * 1em,
    spacing: styles.spaces.par-spacing * 1em,
  )

  set text(
    size: styles.sizes.context * 1pt,
    font: styles.fonts.at(lang).context,
    lang: lang,
  )

  set page(
    header: context {
      if not page-has-first-level-one-heading() {
        set text(size: styles.sizes.header * 1pt)
        align-odd-even(header, emph(hydra(1)))
        line(length: 100%)
      }
    },
    footer: context {
      set text(size: styles.sizes.footer * 1pt)
      let page_num = here().page()
      align-odd-even(footer, page_num)
    },
  )

  align(center, chapter-title(
    title,
    lang: lang,
    styles: styles,
    prefix: prefix,
    chapter-break: chapter-odd-pagebreak,
  ))

  show heading: heading-size-style.with(lang: lang, styles: styles)
  set heading(numbering: (..numbers) => heading-numbering(
    ..numbers,
    prefix: prefix,
    heading-depth: heading-depth,
  ))

  show pagebreak.where(weak: true): it => {
    counter(heading).update(0)
    it
  }

  if outline-on {
    outline(depth: 2)
    pagebreak()
  }

  set math.cases(gap: .85em)
  show math.equation: equation-numbering-style.with(prefix: prefix)
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
  }

  show ref: ref-style.with(lang: lang, names: names).with(prefix: prefix)
  show figure: figure-supplement-style
  show figure.where(kind: table): set figure.caption(position: top)
  show raw.where(block: true): code-block-style

  context if book-state.get() {
    set-inherited-levels(0)
  } else {
    set-inherited-levels(1)
  }

  if prefix == "appendix" {
    set-theorion-numbering("A.1")
  }
  show: show-theorion
  body
}

#let appendix-style = chapter-style.with(prefix: "appendix")
