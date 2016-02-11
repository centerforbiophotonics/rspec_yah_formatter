# PLEASE NOTE - This is a fork from [rspec_reports_formatter](https://github.com/kingsleyh/rspec_reports_formatter)

# Publish pretty [rspec](http://rspec.info/) reports

This is a ruby Rspec custom formatter which generates pretty html reports showing the results of rspec tests. This gem was build to use Rspec 3.x.x

## Install

```
  gem install rspec_yah_formatter -v 0.0.1
```

ideally just add it to your bundler Gemfile as follows:

```ruby
 gem 'rspec_yah_formatter','~> 0.0.1'
```

## Use
When running your rspec tests with rspec 3.0.0 just use the custom formatter:

This should work:

```
 rspec -f RspecYahFormatter spec
```

If not you can explicitly add in a require as follows:

```
 rspec --require rspec_yah_formatter.rb --format RspecYahFormatter spec
```


![example report]
This report is inspired in [rspec_reports_formatter](https://github.com/kingsleyh/rspec_reports_formatter), with some differences:

- All examples are shown in the same page. This makes it simpler, and also 
avoids [this](https://github.com/kingsleyh/rspec_reports_formatter/issues/3)
- **You can add images**. To do that, you have to create a png in the same folder where --out is, and name it `<spec-filename>-<line-with-error>.png`. The formatter will pick up the images automatically. It's quite restrictive, but this will be worked out later.
- To avoid that the page is filled with stacktraces and images, errors are by default hidden, and you can show them by clicking on them.
- This report only makes sense in html, so you must specify a file in `--out`when running rspec
- Removed the "magic" Gherkin processing of the comments on the specs
