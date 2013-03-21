def template(t_file)
  erb = File.read(File.expand_path("../../templates/#{t_file}", __FILE__))
  ERB.new(erb).result(binding)
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

