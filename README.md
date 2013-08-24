# Digitalfilmtree

Assorted libraries for our post production worklow

## Contents

### Digitalfilmtree::VFX::EDLMLRenamer

Renames .mov files per EDL (.edl) and Marker List (.txt)

### Example

```ruby
require 'digitalfilmtree/vfx/edl_ml_renamer'
r = Digitalfilmtree::VFX::EDLMLRenamer.new
r.folder = "folder/with/files"
r.execute
```
  

## Installation

Add this line to your application's Gemfile:

    gem 'digitalfilmtree'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install digitalfilmtree

## Usage

Use parts of it from other apps

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
