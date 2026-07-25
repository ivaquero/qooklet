#import "common.typ": *

#let cover-style(body, styles: default-styles) = {
  book-state.update(true)
  show: book-style.with(styles: styles)
  body
}

#let cover(
  info,
  date: datetime.today(),
  styles: default-styles,
) = {
  show: cover-style

  let title = info.title
  let lang = info.lang
  let author = info.author

  align(center + horizon, [
    #styled-text(
      title,
      size: styles.sizes.cover * 1pt,
      styles: styles,
      lang: lang,
      role: "cover",
      weight: "bold",
    )
    #v(1em)
    #styled-text(
      author,
      size: styles.sizes.author * 1pt,
      styles: styles,
      lang: lang,
      role: "author",
    )
    #v(1em)
    #styled-text(
      date.display(),
      size: styles.sizes.date * 1pt,
      styles: styles,
      lang: lang,
      role: "date",
    )
  ])
}

#let epigraph(
  body,
  info: default-info,
  styles: default-styles,
) = {
  show: cover-style

  let lang = info.lang
  align(center + horizon, styled-text(
    body,
    size: styles.sizes.epigraph * 1pt,
    styles: styles,
    lang: lang,
    role: "epigraph",
  ))
}
