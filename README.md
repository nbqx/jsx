# Jsx

Executing Adobe ExtendScript from Ruby, with preprocessor.

## Installation

Add this line to your application's Gemfile:

    gem 'jsx', :git => 'git://github.com/nbqx/jsx.git', :branch => 'master'

And then execute:

    $ bundle

Or install it yourself as:

    $ git clone git://github.com/nbqx/jsx.git
    $ cd jsx
    $ rake install

## Usage

### Simple Usage

You must write jsx code in `UTF-8`.

From Command Line: 

    $ jsx /path/to/jsx
    
As WebServer:

    $ jsx_server

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
