local Inventory = {}
Inventory.__index = Inventory

function Inventory.new ()
  local inventory = {}
  setmetatable(inventory, Inventory)
  return inventory
end

return Inventory