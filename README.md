# Resumer

Resumer is a Ruby tool that processes resumes written in machine-readable YAML format and produces a well-formatted version in either HTML or PDF.

It was initially inspired by [JSON Resume][jsonresume] but I though YAML would be a more human-readable format for this purpose.

Under the hood, Resumer uses the [commander gem][commander], and produces PDF files using [wkhtmltopdf][wkhtmltopdf], which must be already installed in the system.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resumer'
```

And then execute:

```console
$ bundle install
```

Or install it yourself as:

```console
$ gem install resumer
```

## Usage

Create a new YAML resume file:

```console
$ resumer init [path/to/new/resume.yml]
```

Edit the YAML file with your data, then export it:

```console
$ resumer <sourceFile> [destFile/defaults to sourceFile.pdf/html]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/resumer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Resumer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/resumer/blob/master/CODE_OF_CONDUCT.md).

[jsonresume]: https://jsonresume.org/
[commander]: https://github.com/commander-rb/commander
[wkhtmltopdf]: http://wkhtmltopdf.org/
