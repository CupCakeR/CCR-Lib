local debug = debug
local error = error
local ErrorNoHalt = ErrorNoHalt
local hook = hook
local pairs = pairs
local require = require
local sql = sql
local string = string
local table = table
local timer = timer
local tostring = tostring
local mysqlOO
local TMySQL
local _G = _G
local multistatements
local globalSettings = table.Copy(CCR_MYSQLITE_SETTINGS)
local MySQLite_config = globalSettings.config
local moduleLoaded

local function loadMySQLModule()
  if moduleLoaded || !MySQLite_config || !MySQLite_config.EnableMySQL then return end
  local moo, tmsql = file.Exists("bin/gmsv_mysqloo_*.dll", "LUA"), file.Exists("bin/gmsv_tmysql4_*.dll", "LUA")

  if !moo && !tmsql then
    error("Could not find a suitable MySQL module. Supported modules are MySQLOO and tmysql4.")
  end

  moduleLoaded = true
  require(moo && tmsql && MySQLite_config.Preferred_module || moo && "mysqloo" || "tmysql4")
  multistatements = CLIENT_MULTI_STATEMENTS
  mysqlOO = mysqloo
  TMySQL = tmysql
end

loadMySQLModule()
module(globalSettings.moduleName)

function initialize(config)
  MySQLite_config = config || MySQLite_config

  if !MySQLite_config then
    ErrorNoHalt("Warning: No MySQL config!")
  end

  loadMySQLModule()

  if MySQLite_config.EnableMySQL then
    connectToMySQL(MySQLite_config.Host, MySQLite_config.Username, MySQLite_config.Password, MySQLite_config.Database_name, MySQLite_config.Database_port)
  else
    timer.Simple(0, function()
      hook.Run(globalSettings.moduleName .. ".DatabaseInitialized")
    end)
  end
end

local CONNECTED_TO_MYSQL = false
local msOOConnect
databaseObject = nil
local queuedQueries
local cachedQueries

function isMySQL()
  return CONNECTED_TO_MYSQL
end

function begin()
  if !CONNECTED_TO_MYSQL then
    sql.Begin()
  else
    if queuedQueries then
      debug.Trace()
      error("Transaction ongoing!")
    end

    queuedQueries = {}
  end
end

function commit(onFinished)
  if !CONNECTED_TO_MYSQL then
    sql.Commit()

    if onFinished then
      onFinished()
    end

    return
  end

  if !queuedQueries then
    error("No queued queries! Call begin() first!")
  end

  if #queuedQueries == 0 then
    queuedQueries = nil

    if onFinished then
      onFinished()
    end

    return
  end


  local queue = table.Copy(queuedQueries)
  queuedQueries = nil

  local queuePos = 0
  local call


  call = function(...)
    queuePos = queuePos + 1

    if queue[queuePos].callback then
      queue[queuePos].callback(...)
    end


    if queuePos + 1 > #queue then

      if onFinished then
        onFinished()
      end

      return
    end


    local nextQuery = queue[queuePos + 1]
    query(nextQuery.query, call, nextQuery.onError)
  end

  query(queue[1].query, call, queue[1].onError)
end

function queueQuery(sqlText, callback, errorCallback)
  if CONNECTED_TO_MYSQL then
    table.insert(queuedQueries, {
      query = sqlText,
      callback = callback,
      onError = errorCallback
    })

    return
  end


  query(sqlText, callback, errorCallback)
end

local function msOOQuery(sqlText, callback, errorCallback, queryValue)
  local queryObject = databaseObject:query(sqlText)
  local data

  queryObject.onData = function(Q, D)
    data = data || {}
    data[#data + 1] = D
  end

  queryObject.onError = function(Q, E)
    if databaseObject:status() == mysqlOO.DATABASE_NOT_CONNECTED then
      table.insert(cachedQueries, {
        sqlText, callback, queryValue})

      msOOConnect(MySQLite_config.Host, MySQLite_config.Username, MySQLite_config.Password, MySQLite_config.Database_name, MySQLite_config.Database_port)

      return
    end

    local supp = errorCallback && errorCallback(E, sqlText)

    if !supp then
      error(E .. " (" .. sqlText .. ")")
    end
  end

  queryObject.onSuccess = function()
    local res = queryValue && data && data[1] && table.GetFirstValue(data[1]) || !queryValue && data || nil

    if callback then
      callback(res, queryObject:lastInsert())
    end
  end

  queryObject:start()
end

local function tmsqlQuery(sqlText, callback, errorCallback, queryValue)
  local call = function(res)
    res = res[1]

    if !res.status then
      local supp = errorCallback && errorCallback(res.error, sqlText)

      if !supp then
        error(res.error .. " (" .. sqlText .. ")")
      end

      return
    end


    if !res.data || #res.data == 0 then
      res.data = nil
    end

    if queryValue && callback then return callback(res.data && res.data[1] && table.GetFirstValue(res.data[1]) || nil)end

    if callback then
      callback(res.data, res.lastid)
    end
  end

  databaseObject:Query(sqlText, call)
end

local function SQLiteQuery(sqlText, callback, errorCallback, queryValue)
  sql.m_strError = ""
  local lastError = sql.LastError()
  local Result = queryValue && sql.QueryValue(sqlText) || sql.Query(sqlText)

  if sql.LastError() && sql.LastError() != lastError then
    local err = sql.LastError()
    local supp = errorCallback && errorCallback(err, sqlText)

    if supp == false then
      error(err .. " (" .. sqlText .. ")", 2)
    end

    return
  end

  if callback then
    callback(Result)
  end

  return Result
end

function query(sqlText, callback, errorCallback)
  local qFunc = (CONNECTED_TO_MYSQL && ((mysqlOO && msOOQuery) || (TMySQL && tmsqlQuery))) || SQLiteQuery

  return qFunc(sqlText, callback, errorCallback, false)
end

function queryValue(sqlText, callback, errorCallback)
  local qFunc = (CONNECTED_TO_MYSQL && ((mysqlOO && msOOQuery) || (TMySQL && tmsqlQuery))) || SQLiteQuery

  return qFunc(sqlText, callback, errorCallback, true)
end

local function onConnected()
  CONNECTED_TO_MYSQL = true


  for k, v in pairs(cachedQueries || {}) do
    cachedQueries[k] = nil

    if v[3] then
      queryValue(v[1], v[2])
    else
      query(v[1], v[2])
    end
  end

  cachedQueries = {}
  hook.Call(globalSettings.moduleName .. ".DatabaseInitialized")
end

msOOConnect = function(host, username, password, database_name, database_port)
  databaseObject = mysqlOO.connect(host, username, password, database_name, database_port)

  if timer.Exists("darkrp_check_mysql_status") then
    timer.Remove("darkrp_check_mysql_status")
  end

  databaseObject.onConnectionFailed = function(_, msg)
    timer.Simple(5, function()
      msOOConnect(MySQLite_config.Host, MySQLite_config.Username, MySQLite_config.Password, MySQLite_config.Database_name, MySQLite_config.Database_port)
    end)

    error("Connection failed! " .. tostring(msg) .. "\nTrying again in 5 seconds.")
  end

  databaseObject.onConnected = onConnected
  databaseObject:connect()
end

local function tmsqlConnect(host, username, password, database_name, database_port)
  local db, err = TMySQL.initialize(host, username, password, database_name, database_port, nil, MySQLite_config.MultiStatements && multistatements || nil)

  if err then
    error("Connection failed! " .. err .. "\n")
  end

  databaseObject = db
  onConnected()
end

function connectToMySQL(host, username, password, database_name, database_port)
  database_port = database_port || 3306
  local func = mysqlOO && msOOConnect || TMySQL && tmsqlConnect || function() end
  func(host, username, password, database_name, database_port)
end

function SQLStr(sqlStr)
  local escape = !CONNECTED_TO_MYSQL && sql.SQLStr || mysqlOO && function(str)
    return "\"" .. databaseObject:escape(tostring(str)) .. "\""end || TMySQL && function(str)
    return "\"" .. databaseObject:Escape(tostring(str)) .. "\""end

  return escape(sqlStr)
end

function tableExists(tbl, callback, errorCallback)
  if !CONNECTED_TO_MYSQL then
    local exists = sql.TableExists(tbl)
    callback(exists)

    return exists
  end

  queryValue(string.format("SHOW TABLES LIKE %s", SQLStr(tbl)), function(v)
    callback(v != nil)
  end, errorCallback)
end
