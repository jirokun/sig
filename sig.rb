# -*- encoding: utf-8 -*-
#  Copyright (c) 2012, Jiro Iwamoto 
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without modification,
#  are permitted provided that the following conditions are met:
#
#    1. Redistributions of source code must retain the above copyright notice, 
#       this list of conditions and the following disclaimer.
#    2. Redistributions in binary form must reproduce the above copyright notice, 
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS  PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
#  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
#  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
