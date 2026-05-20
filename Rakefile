
desc 'Run test'
task :test do
  puts `ruby test/test-four-pillars.rb`
end

namespace :gem do
  desc 'Build gem'
  task :build do
    puts `gem build four-pillars.gemspec`
    puts "`gem push four-pillars-0.x.x.gem` to publish the gem."
    puts "See https://guides.rubygems.org/make-your-own-gem/ for details."
  end
end

namespace :build do
  desc 'Build self-contained dist/index.html for WASM / GitHub Pages'
  task :wasm do
    require 'fileutils'
    FileUtils.mkdir_p 'dist'

    setsuiri_data = File.read('lib/four-pillars-setsuiri.txt')
    fp_rb         = File.read('lib/four-pillars.rb')

    patched_fp_rb = fp_rb.sub(
      'open(__dir__+"/four-pillars-setsuiri.txt")',
      'StringIO.new(SETSUIRI_DATA_EMBEDDED)'
    )
    abort 'ERROR: patch target not found in lib/four-pillars.rb' if patched_fp_rb == fp_rb

    html = File.read('playground/index.html')
    existing_ruby = html[/<script type="text\/ruby">(.*?)<\/script>/m, 1]
    abort 'ERROR: <script type="text/ruby"> block not found in playground/index.html' unless existing_ruby

    ui_marker = '  # --- Wire up the UI ---'
    ui_offset  = existing_ruby.index(ui_marker)
    abort 'ERROR: UI wiring marker not found in script block' unless ui_offset
    ui_code = existing_ruby[ui_offset..].rstrip

    new_script = [
      'require "js"',
      'require "stringio"',
      '',
      'SETSUIRI_DATA_EMBEDDED = <<~CSV',
      setsuiri_data.chomp,
      'CSV',
      '',
      patched_fp_rb.rstrip,
      '',
      ui_code,
    ].join("\n")

    new_html = html.sub(
      /<script type="text\/ruby">.*?<\/script>/m,
      "<script type=\"text/ruby\">\n#{new_script}\n</script>"
    )

    out = 'dist/index.html'
    File.write(out, new_html)
    puts "Built #{out} (#{(new_html.bytesize / 1024.0).round(1)} KB)"
  end
end
