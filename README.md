# Publish pretty [rspec](http://rspec.info/) reports with images

**PLEASE NOTE - This is a fork from [rspec_reports_formatter](https://github.com/kingsleyh/rspec_reports_formatter)**

This is a RSpec formatter which generates pretty html reports showing the results of rspec tests, where you can also easily attach images and screenshots.

## Why another formatter?

On CI servers, xUnit xml test reports are quite "standard", but the attachments cannot be linked to a concrete test. I mean, just [look at this](https://wiki.jenkins-ci.org/download/attachments/42467572/junit-attachments.png).

kingsleyh created a nicer interface using an RSpec formatter with [rspec_reports_formatter](https://github.com/kingsleyh/rspec_reports_formatter), but it had some issues with nested blocks and it was still not possible to attach images.

With `rspec_yah_formatter` you can attach images, which is very useful for `capybara`, `selenium` and so on.



## Features

This report is inspired in [rspec_reports_formatter](https://github.com/kingsleyh/rspec_reports_formatter), with some differences:

- All examples are shown in the same page. This makes it simpler, and also
avoids [this](https://github.com/kingsleyh/rspec_reports_formatter/issues/3)
- As mentioned, you can add images
- To avoid that the page is filled with stacktraces and images, errors are by default hidden, and you can show them by clicking on them.
- This report only makes sense in html, so you must specify a file in `--out`when running rspec

Here is also the [Changelog](../../wiki/Changelog) and a [TODO list](../../wiki/TODO-list)

## Install

This gem was build to use Rspec 3.x.x

```
  gem install rspec_yah_formatter -v 0.0.7
```

ideally just add it to your bundler Gemfile as follows:

```ruby
 gem 'rspec_yah_formatter','~> 0.0.7'
```

## Use

When running your rspec tests with rspec 3.0.0 just use the custom formatter:

This should work:

```
 rspec spec/my/spec -f RspecYahFormatter --out path/to/report.html
```

If not you can explicitly add in a require as follows:

```
 rspec spec/my/spec --require rspec_yah_formatter.rb --format RspecYahFormatter --out path/to/report.html
```

To add images:

```
RSpec.configure do |config|
  config.after(:each) do |example|
    if example.exception
        # Save screenshot to 'path/to/foo.png'
        example.metadata[:screenshot] = 'path/to/foo.png'
    end
  end
end
```
