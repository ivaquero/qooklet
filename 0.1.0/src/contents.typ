#import "deps.typ": default-info, default-names, default-styles
#import "common.typ": *

#let contents-style(
  body,
  depth: 2,
  lang: "en",
  names: default-names,
  styles: default-styles,
) = {
  assert(depth in (1, 2), message: "depth can only be either 1 or 2")

  show: book-style.with(styles: styles)
  show link: set text(black)
  show: styled-text.with(styles: styles, lang: lang, role: "contents", as-style: true)
  show heading.where(level: 1): it => {
    set text(
      size: styles.sizes.contents * 1pt,
      ..font-role-options(styles, lang, "contents"),
    )
    it
    v(.5em)
  }

  set outline(title: {
    heading(
      outlined: true,
      level: 1,
      names.sections.at(lang).content,
    )
  })

  show outline.entry: x => {
    let fill = box(width: 1fr, x.fill)
    let loc = x.element.location()
    let prefix = x.prefix()
    let bold-entry(body) = strong(body) + fill + x.page() + v(0em)

    let chapter-index = counter-chapter.at(loc).at(0)
    let append-index = counter-appendix.at(loc).at(0)

    if (depth >= 1) and (x.element.func() == figure) {
      let entry-body = smallcaps(x.body())
      let chap-prefix = str(chapter-index) + "." + h(0.5em)

      let kind = x.element.kind
      if kind == "part" {
        link(loc, bold-entry(entry-body))
      } else if kind == "chapter" {
        link(loc, chap-prefix + bold-entry(entry-body))
      } else if kind == "appendix" {
        let append-prefix = appendix-number(append-index) + "." + h(0.5em)
        link(loc, append-prefix + bold-entry(entry-body))
      }
    } else if (
      (depth == 2) and (x.level == 1) and (prefix != none) and (append-index == 0)
    ) {
      link(
        loc,
        (
          if prefix.has("children") {
            (
              h(styles.spaces.contents-indent * 1em)
                + str(chapter-index)
                + "."
                + prefix.children.at(1)
                + h(.5em)
                + x.body()
                + fill
                + x.page()
                + v(0em)
            )
          } else if prefix.has("text") {
            (
              prefix
                + h(.5em)
                + x.body()
                + fill
                + x.page()
                + v(0em)
            )
          }
        ),
      )
    }
  }
  styled-text(body, styles: styles, lang: lang, role: "contents")
}

#let contents(
  depth: 2,
  info: default-info,
  styles: default-styles,
) = {
  let lang = info.lang

  show: contents-style.with(
    lang: lang,
    depth: depth,
    styles: styles,
  )
  outline(
    target: selector(heading).or(fig-part).or(fig-chapter).or(fig-appendix),
    depth: depth,
  )
  pagebreak(to: "odd")
}
