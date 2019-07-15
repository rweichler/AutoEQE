-- for var in */*Parametric*.txt; do lua convert_autoeq.lua "$var"; done

local kind2name = {
    PK = 'eq',
}

print(arg[1])
local filename = string.gsub(string.gsub(arg[1], '%.txt', '.lua'), '\n', '')
local fo, err = io.open(filename, 'w')

local readme_filename = string.gsub(arg[1], '%/.*', '/README.md')
local readme = io.open(readme_filename, 'r'):read('*a')
local preamp = string.match(readme, 'In case of using parametric equalizer, apply preamp of %*%*(.*)dB%*%* and build filters manually')
preamp = tonumber(preamp)
print(preamp)

if err then
    error(err)
end
local function print(s)
    fo:write(s)
    fo:write('\n')
end

print('return {')

if preamp then
    print('    {')
    print('        name = "preamp",')
    print('        gain = '..preamp..',')
    print('    },')
end

local f = io.open(arg[1], 'r')
for line in f:lines() do
    local kind, fc, gain, q = line:match('Filter %d+%: ON (.+) Fc (%-?%d+%.?%d*) Hz Gain (%-?%d+%.?%d*) dB Q (%-?%d+%.?%d*)')
    print('    {')
    print('        name = "'..kind2name[kind]..'",')
    print('        gain = '..gain..',')
    print('        frequency = '..fc..',')
    print('        Q = '..q..',')
    print('    },')
end
print('}')

fo:close()
