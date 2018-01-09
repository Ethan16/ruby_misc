require 'tk'

root = TkRoot.new { title 'James' }
TkLabel.new(root) do
  text 'Hello world!'
  pack('padx' => 100, 'pady' => 80, 'side' => 'left')
end

Tk.mainloop