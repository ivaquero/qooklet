# SciBook

A simple book template for scientific books and manuals.

## Usage

### Clone Official Repository

To compile, please refer to the guide on [typst-packages](https://github.com/typst/packages) and clone this repository to your `@local` workspace:

- Linux：
  - `$XDG_DATA_HOME/typst/packages/local`
  - `~/.local/share/typst/packages/local`
- macOS：`~/Library/Application\ Support/typst/packages/local`
- Windows：`%APPDATA%/typst/packages/local`

### Import the Template

Clone the [scibook](https://github.com/ivaquero/scibook) repository in the above path, and then import it in the document

```typst
#import "@local/scibook:0.1.0": *
```
