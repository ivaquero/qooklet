#import "@preview/hydra:0.6.3": hydra
#import "@preview/codly:1.3.0": *
#import "@preview/theorion:0.6.0": *

#let default-names = toml("config/names.toml")
#let default-styles = toml("config/styles.toml")
#let default-info = toml("config/info.toml").global

#let font-for(styles, lang, role) = {
  if not styles.keys().contains("font-fallbacks") {
    return styles.fonts.at(lang).at(role)
  }

  let fallback-fonts = styles.at("font-fallbacks")
  let platform = sys.inputs.at(
    "qooklet-font-platform",
    default: styles.at("font-platform", default: "default"),
  )
  let platform-fonts = fallback-fonts.at(platform, default: fallback-fonts.at("default", default: (:)))

  if platform-fonts.keys().contains(lang) {
    let lang-fonts = platform-fonts.at(lang)
    if lang-fonts.keys().contains(role) and lang-fonts.at(role) != "" {
      return lang-fonts.at(role)
    }
  }

  let default-fonts = fallback-fonts.at("default", default: (:))
  if default-fonts.keys().contains(lang) {
    let lang-fonts = default-fonts.at(lang)
    if lang-fonts.keys().contains(role) and lang-fonts.at(role) != "" {
      return lang-fonts.at(role)
    }
  }

  styles.fonts.at(lang).at(role)
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
  let selected-font = if role == "" { font } else { font-for(styles, lang, role) }
  text(body, ..font-options(selected-font), ..options)
}

#let tip = tip-block
#let note = note-block
#let quote = quote-block
#let warning = warning-block
#let caution = caution-block
