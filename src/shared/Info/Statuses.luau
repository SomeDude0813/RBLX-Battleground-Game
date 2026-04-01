local module = {
	["Stun"] = { WalkSpeed = 0, JumpHeight = 0 },
	["LockWalk"] = { WalkSpeed = 0, JumpHeight = 1 },
	["LockJump"] = { WalkSpeed = 1, JumpHeight = 0 },
	["Speed"] = { WalkSpeed = 1.2, JumpHeight = 1 },
	["Slow"] = { WalkSpeed = 0.5, JumpHeight = 1 },
}

return table.freeze(module)
