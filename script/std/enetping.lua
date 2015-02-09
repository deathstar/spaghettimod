--[[

  Force ping statistics to be taken from the enet peers.

]]--

local fp, L, iterators = require"utils.fp", require"utils.lambda", require"std.iterators"

spaghetti.addhook(server.N_CLIENTPING, L"_.skip = true")

local refresh
spaghetti.later(250, function()
  for ci in iterators.all() do
    local oldping
    oldping, ci.ping = ci.ping, engine.getclientpeer(ci.ownernum).roundTripTime
    if (refresh or oldping ~= ci.ping) and ci.state.aitype == server.AI_NONE then ci.messages:putint(server.N_CLIENTPING):putint(ci.ping) end
  end
  refresh = false
end, true)

spaghetti.addhook("connected", function() refresh = true end)