# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^views/(.+)\.erb$})
  watch('spec/spec_helper.rb') { "spec" }
  watch('main.rb') { "spec/main_spec.rb" }
end
