local M = {}

local prayers = { "Fajr", "Dhuhr", "Asr", "Maghrib", "Isha" }
local cached = {}
local next_prayer = { name = "", time = "" }

local function parse_time(t)
  local h, m = t:match("(%d+):(%d+)")
  return tonumber(h), tonumber(m)
end

local function time_to_minutes(h, m)
  return h * 60 + m
end

local function now_minutes()
  local t = os.date("*t")
  return time_to_minutes(t.hour, t.min)
end

local function update_next_prayer()
  if vim.tbl_isempty(cached) then return end
  local now = now_minutes()
  for _, name in ipairs(prayers) do
    local t = cached[name]
    if t then
      local h, m = parse_time(t)
      if time_to_minutes(h, m) > now then
        next_prayer = { name = name, time = t }
        return
      end
    end
  end
  -- kalau sudah lewat semua, next adalah Fajr
  next_prayer = { name = "Fajr (esok)", time = cached["Fajr"] or "" }
end

local function notify_prayer(name, time)
  vim.notify(
    "🕌 Waktu " .. name .. " - " .. time,
    vim.log.levels.INFO,
    { title = "Jadwal Sholat", timeout = 10000 }
  )
end

local function check_reminders()
  if vim.tbl_isempty(cached) then return end
  local t = os.date("*t")
  local now_h = t.hour
  local now_m = t.min

  for _, name in ipairs(prayers) do
    local ptime = cached[name]
    if ptime then
      local h, m = parse_time(ptime)
      -- notif tepat waktu dan 5 menit sebelumnya
      if h == now_h and m == now_m then
        notify_prayer(name, ptime)
      elseif h == now_h and (m - now_m) == 5 then
        vim.notify(
          "⏰ " .. name .. " dalam 5 menit (" .. ptime .. ")",
          vim.log.levels.WARN,
          { title = "Pengingat Sholat", timeout = 8000 }
        )
      end
    end
  end

  update_next_prayer()
end

local function fetch_prayer_times()
  local date = os.date("%d-%m-%Y")
  local url = "https://api.aladhan.com/v1/timings/"
    .. date
    .. "?latitude=-6.2897&longitude=106.6577&method=20"

  local stdout = {}
  vim.fn.jobstart({ "curl", "-s", url }, {
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          table.insert(stdout, line)
        end
      end
    end,
    on_exit = function()
      local result = table.concat(stdout, "")
      local ok, json = pcall(vim.fn.json_decode, result)
      if not ok or not json or not json.data then return end

      local timings = json.data.timings
      cached = {
        Fajr    = timings.Fajr,
        Dhuhr   = timings.Dhuhr,
        Asr     = timings.Asr,
        Maghrib = timings.Maghrib,
        Isha    = timings.Isha,
      }
      update_next_prayer()
    end,
  })
end

function M.get_next_prayer()
  if next_prayer.name == "" then
    return ""
  end
  return "🕌 " .. next_prayer.name .. " " .. next_prayer.time
end

function M.show_schedule()
  if vim.tbl_isempty(cached) then
    vim.notify("Jadwal sholat belum dimuat", vim.log.levels.WARN)
    return
  end

	local today = os.date("%d/%m/%Y")

  local lines = {
    "  Jadwal Sholat - " .. today,
    "  Tangerang Selatan",
    "",
    "  - Fajr     " .. (cached.Fajr or "-"),
    "  - Dhuhr    " .. (cached.Dhuhr or "-"),
    "  - Asr      " .. (cached.Asr or "-"),
    "  - Maghrib  " .. (cached.Maghrib or "-"),
    "  - Isha     " .. (cached.Isha or "-"),
  }

  -- highlight next prayer
  local now = now_minutes()
  for i, name in ipairs(prayers) do
    local ptime = cached[name]
    if ptime then
      local h, m = parse_time(ptime)
      if time_to_minutes(h, m) > now then
        lines[i + 3] = lines[i + 3] .. "  ← berikutnya"
        break
      end
    end
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, {
    title = "Jadwal Sholat",
    timeout = 10000,
  })
end

function M.setup()
	vim.api.nvim_create_user_command("PrayerTime", function()
		M.show_schedule()
	end, { desc = "Tampilkan jadwal sholat hari ini" })
  -- fetch saat startup
  fetch_prayer_times()

  -- refresh setiap hari sekali (jam 00:01)
  -- dan check reminder setiap menit
  local timer = vim.loop.new_timer()
  timer:start(0, 60000, vim.schedule_wrap(function()
    local t = os.date("*t")
    if t.hour == 0 and t.min == 1 then
      fetch_prayer_times()
    end
    check_reminders()
  end))

	vim.loop.new_timer():start(0, 60000, vim.schedule_wrap(function()
    if package.loaded["lualine"] then
		  require("lualine").refresh()
    end
	end))
end

return M
