Utils = {}
      --- Returns HEX representation of num
function Utils.num2hex(num)
  local hexstr = '0123456789abcdef'
  local s = ''
  while num > 0 do
  local mod = math.fmod(num, 16)
  s = string.sub(hexstr, mod+1, mod+1) .. s
  num = math.floor(num / 16)
  end
  if s == '' then s = '0' end
  return s
end

return Utils