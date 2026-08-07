--- @since 25.5.31
---
--- Copy the path of the hovered file relative to the git repo root.
--- If not inside a git repo, copy the absolute path instead.

local get_hovered_url = ya.sync(function()
	local h = cx.active.current.hovered
	return h and tostring(h.url)
end)

return {
	entry = function()
		local abs = get_hovered_url()
		if not abs then
			return ya.notify({ title = "copy-root-rel-path", content = "No file hovered", level = "warn", timeout = 3 })
		end

		-- Derive parent directory from the absolute path
		local dir = abs:match("^(.*)/[^/]*$") or abs

		-- Try to get the git repo root
		local output, _ = Command("git")
			:arg("-C"):arg(dir):arg("rev-parse"):arg("--show-toplevel")
			:output()

		local path
		if output and output.status.success then
			local root = output.stdout:gsub("%s+$", "") -- trim trailing newline/whitespace
			if abs:sub(1, #root) == root then
				path = abs:sub(#root + 2) -- strip root prefix and the following "/"
			else
				path = abs
			end
		else
			path = abs
		end

		ya.clipboard(path)
		ya.notify({
			title = "copy-root-rel-path",
			content = "Copied: " .. path,
			level = "info",
			timeout = 3,
		})
	end,
}
