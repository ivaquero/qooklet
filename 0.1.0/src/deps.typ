#import "@preview/hydra:0.6.3": hydra
#import "@preview/codly:1.3.0": *
#import "@preview/theorion:0.6.0": *

#let default-names = toml("config/names.toml")
#let default-styles = toml("config/styles.toml")
#let default-info = toml("config/info.toml").global

#let latin-coverage = regex("[A-Za-z0-9.,:;!?()\\[\\]]")

#let base-font-for(styles, lang, role) = {
  if not styles.keys().contains("font-fallbacks") {
    return styles.fonts.at(lang).at(role)
  }

  let fallback-fonts = styles.at("font-fallbacks")
  let platform = sys.inputs.at(
    "qooklet-font-platform",
    default: styles.at("font-platform", default: "default"),
  )

  let get-font(lang) = {
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

  let base-font = get-font(lang)
  base-font
}

#let latin-font-for(styles, role) = {
  if styles.keys().contains("font-fallbacks") {
    let fallback-fonts = styles.at("font-fallbacks")
    let platform = sys.inputs.at(
      "qooklet-font-platform",
      default: styles.at("font-platform", default: "default"),
    )

    for platform-name in (platform, "default") {
      let platform-fonts = fallback-fonts.at(platform-name, default: (:))
      if platform-fonts.keys().contains("zh-latin") {
        let lang-fonts = platform-fonts.at("zh-latin")
        if lang-fonts.keys().contains(role) and lang-fonts.at(role) != "" {
          return lang-fonts.at(role)
        }
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
    show latin-coverage: set text(
      font: latin-font-for(styles, role),
      weight: "regular",
    )
    text(body, ..font-options(selected-font), ..options)
  } else {
    text(body, ..font-options(selected-font), ..options)
  }
}

#let tip = tip-block
#let note = note-block
#let quote = quote-block
#let warning = warning-block
#let caution = caution-block
