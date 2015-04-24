local TRAIT = {}

function TRAIT:AddHook(name, id, fn)
	self._hooks = self._hooks or {}
	self._hooks[name] = self._hooks[name] or {}
	self._hooks[name][id] = fn
end

function TRAIT:CallHook(name, ...)
	if not self._hooks then return end

	local nmhooks = self._hooks[name]
	if not nmhooks then return end

	for _,fn in pairs(nmhooks) do
		fn(...)
	end
end

nsgui.trait.Register("hooks", TRAIT)