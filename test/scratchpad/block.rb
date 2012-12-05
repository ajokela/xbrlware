def first(name, &block)
  block = lambda{ puts "lambda"} if block.nil?
  second &block
end

def second(&block)
  yield
end

first("blk") { puts "Hello"}
first("blk")


def dummy(count, snipet=StringIO.new, &block)
  return snipet.string if count > 5
  yield snipet
  count += 1
  dummy(count, snipet, &block)
end

dummy(0, StringIO.new) {|snipet| snipet << "x"}


def block_taking_block(&block)
  yield 10   
end

block_taking_block do |j|
  x = lambda do |y|
    puts y    
  end
  x.call j
end

require 'active_support'
Hash.from_xml('')