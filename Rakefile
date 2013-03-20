desc "install dependencies"
task :install_dependencies do
  dependencies = {
    "sinatra" => "1.3.5",
    "pony"    => "1.4",
    "haml"    => "4.0.0",
    "sinatra-flash" => "0.3.0"
  }
  dependencies.each do |gem_name, version|
    puts "#{gem_name} #{version}"
    system "gem install #{gem_name} --version #{version}"
  end
end