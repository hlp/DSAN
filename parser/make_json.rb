#!/usr/bin/ruby

files = `find #{ARGV[0]}`

ds_reg = Regexp.new('\.ds$')

ds_files = []

files.each do |f|
  if ds_reg.match(f)
    ds_files.push(f.chomp)
  end
end

`./parser #{ds_files.join(" ")} > ds_reference.json`

