def toggle(list, item)
  if list.include? item
    list -= item
  else
    list += item
  end
end

def iterate(from, to, &command)
  for i j [] do
    yield(list, item)
  end
end

iterate([100,55], [222, 75]) { |list, include| toggle }


