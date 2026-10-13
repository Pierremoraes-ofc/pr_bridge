local api = lib.__native('bridge/library/init')
lib.require = api.require
lib.load, lib.loadJson = api.load, api.loadJson
package = api.package
return lib.require
