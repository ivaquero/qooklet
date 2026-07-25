#import "@preview/hydra:0.6.3": hydra
#import "@preview/codly:1.3.0": *
#import "@preview/theorion:0.6.0": *

#let default-names = toml("config/names.toml")
#let default-styles = toml("config/styles.toml")
#let default-info = toml("config/info.toml").global

#let latin-coverage = regex("[\\p{Latin}\\p{Mark}0-9.,:;!?()\\[\\]'’\\-–—]")

#let font-platform-for(styles) = {
  sys.inputs.at(
    "qooklet-font-platform",
    default: styles.at("font-platform", default: "default"),
  )
}

#let font-fallback-for(styles, platform, lang, role) = {
  let fallback-fonts = styles.at("font-fallbacks", default: (:))
  let platform-fonts = fallback-fonts.at(platform, default: (:))
  if platform-fonts.keys().contains(lang) {
    let lang-fonts = platform-fonts.at(lang)
    if lang-fonts.keys().contains(role) and lang-fonts.at(role) != "" {
      return lang-fonts.at(role)
    }
  }
  none
}

#let base-font-for(styles, lang, role) = {
  if styles.keys().contains("font-fallbacks") {
    let platform = font-platform-for(styles)
    for platform-name in (platform, "default") {
      let font = font-fallback-for(styles, platform-name, lang, role)
      if font != none {
        return font
      }
    }
  }

  styles.fonts.at(lang).at(role)
}

#let latin-font-for(styles, role) = {
  if styles.keys().contains("font-fallbacks") {
    let platform = font-platform-for(styles)
    for platform-name in (platform, "default") {
      let font = font-fallback-for(styles, platform-name, "zh-latin", role)
      if font != none {
        return font
      }
    }
  }

  base-font-for(styles, "en", role)
}

#let font-for(styles, lang, role) = {
  let base-font = base-font-for(styles, lang, role)
  if lang == "zh" {
    return ((name: latin-font-for(styles, role), covers: latin-coverage), base-font)
  }
  base-font
}

#let font-options(font) = if font == "" { (:) } else { (font: font) }

#let font-role-options(styles, lang, role) = {
  font-options(font-for(styles, lang, role))
}

#let styled-text(
  body,
  font: "",
  styles: default-styles,
  lang: "en",
  role: "",
  ..options,
) = {
  let selected-font = if role == "" {
    font
  } else if lang == "zh" {
    base-font-for(styles, lang, role)
  } else {
    font-for(styles, lang, role)
  }
  if lang == "zh" and role != "" {
    let text-weight = options.named().at("weight", default: "regular")
    show latin-coverage: set text(
      font: latin-font-for(styles, role),
      weight: text-weight,
    )
    text(body, ..font-options(selected-font), ..options)
  } else {
    text(body, ..font-options(selected-font), ..options)
  }
}

#let zh-latin-style(
  body,
  styles: default-styles,
  lang: "en",
  role: "context",
) = {
  if lang == "zh" {
    show latin-coverage: set text(
      font: latin-font-for(styles, role),
      weight: "regular",
    )
  }
  body
}

#let tip = tip-block
#let note = note-block
#let quote = quote-block
#let warning = warning-block
#let caution = caution-block
