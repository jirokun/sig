# -*- encoding: utf-8 -*-
require 'sinatra'
require 'cairo'

def generate width, height, params
  content_type 'image/png'
  opts = {
    'font' => 'Gothic',
    'background-color' => 'ccc',
    'color' => '000',
    'opacity' => 1,
    'text' => "#{width} x #{height}"
  }
  opts.merge! params
  surface = Cairo::ImageSurface.new(width, height)
  context = Cairo::Context.new(surface)
  context.set_source_color('#' + opts['background-color'])
  context.rectangle(0, 0, width, height)
  context.fill

  context.set_source_color('#' + opts['color'])
  context.select_font_face(opts['font'], 0,0)
  size = 10
  while true
    context.set_font_size size
    text_extents = context.text_extents(opts['text'])
    if text_extents.width * 1.3  > width
      context.set_font_size size - 1
      break
    end
    size += 1
  end
  text_extents = context.text_extents(opts['text'])
  context.move_to width / 2 - text_extents.width / 2, height / 2 + text_extents.height / 2
  context.show_text(opts['text'])

  out = StringIO.new
  surface.write_to_png out
  out.string
end

if ARGV.size == 1
  port_str = ARGV.shift
  port = port_str.to_i
  if port == 0
    abort port_str + " is not port number"
  end
  set :port, port
end

get %r{/(\d+)x(\d+)$} do |width, height|
  generate width.to_i, height.to_i, params
end
