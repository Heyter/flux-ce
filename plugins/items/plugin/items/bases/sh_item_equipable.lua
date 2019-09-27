if !ItemUsable then
  require_relative 'sh_item_usable'
end

class 'ItemEquipable' extends 'ItemUsable'

ItemEquipable.name = 'Equipment Base'
ItemEquipable.description = 'An item that can be equipped.'
ItemEquipable.category = 'item.category.equipment'
ItemEquipable.stackable = false
ItemEquipable.equip_slot = 'item.slot.accessory'
ItemEquipable.equip_inv = 'hotbar'
ItemEquipable.action_sounds = {
  ['equip'] = 'items/battery_pickup.wav',
  ['unequip'] = 'items/battery_pickup.wav'
}

if CLIENT then
  function ItemEquipable:get_use_text()
    if self:is_equipped() then
      return t'item.option.unequip'
    else
      return t'item.option.equip'
    end
  end

  function ItemEquipable:is_action_visible(act)
    if act == 'use' and IsValid(self.entity) then
      return false
    end
  end
end

function ItemEquipable:is_equipped()
  return self.inventory_type == self.equip_inv
end

function ItemEquipable:can_transfer(inventory, x, y)
  local player = self:get_player()
  local inv_type = inventory.type

  if inv_type == self.equip_inv then
    if self:can_equip(player) == false then
      return false
    end

    for k, v in pairs(player:get_items(self.equip_inv)) do
      if v.equip_slot and v:is_equipped() and v.instance_id != self.instance_id then
        if v.equip_slot == self.equip_slot then
          return false
        elseif istable(self.equip_slot) then
          for k1, v1 in pairs(self.equip_slot) do
            if v1 == v.equip_slot then
              return false
            elseif istable(v.equip_slot) then
              for k2, v2 in pairs(v.equip_slot) do
                if v1 == v2 then
                  return false
                end
              end
            end
          end
        end
      end
    end
  elseif inv_type != self.equip_inv and self.inventory_type == self.equip_inv then
    if self:can_unequip(player) == false then
      return false
    end
  end
end

function ItemEquipable:can_equip(player)
end

function ItemEquipable:can_unequip(player)
end

function ItemEquipable:post_equipped(player)
end

function ItemEquipable:post_unequipped(player)
end

function ItemEquipable:equip(player, should_equip)
  if should_equip then
    self:post_equipped(player)

    hook.run('OnItemEquipped', player, self)
  else
    self:post_unequipped(player)

    hook.run('OnItemUnequipped', player, self)
  end
end

function ItemEquipable:on_transfer(new_inventory, old_inventory)
  local player = self:get_player()

  if IsValid(player) then
    if new_inventory and new_inventory.type == self.equip_inv then
      player:EmitSound(self.action_sounds['equip'])
      self:equip(player, true)
    elseif old_inventory and old_inventory.type == self.equip_inv then
      player:EmitSound(self.action_sounds['unequip'])
      self:equip(player, false)
    end
  end
end

function ItemEquipable:on_use(player)
  if IsValid(self.entity) then
    self:do_menu_action('on_take', player, { inv_type = self.equip_inv })
  else
    if self:is_equipped() then
      player:transfer_item(self.instance_id, 'main_inventory')
    else
      player:transfer_item(self.instance_id, self.equip_inv)
    end
  end

  return true
end

function ItemEquipable:on_loadout(player)
  if self:is_equipped() then
    self:equip(player, true)
  end
end
